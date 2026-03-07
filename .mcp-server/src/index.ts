import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { CallToolRequestSchema, ListToolsRequestSchema } from "@modelcontextprotocol/sdk/types.js";
import { exec } from "child_process";
import { promisify } from "util";
import * as path from "path";
import * as fs from "fs/promises";

const execAsync = promisify(exec);
const projectRoot = path.resolve(process.cwd(), "..");

const server = new Server(
  { name: "ethioshop-mcp", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

// Register tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "flutter_pub_get",
        description: "Run flutter pub get to update dependencies",
        inputSchema: { type: "object", properties: {} }
      },
      {
        name: "run_build_runner",
        description: "Run build_runner to generate code for Riverpod, Freezed, Retrofit, and Hive",
        inputSchema: { type: "object", properties: {} }
      },
      {
        name: "wipe_hive_caches",
        description: "Wipe Hive database caches and generated local storage files",
        inputSchema: { type: "object", properties: {} }
      },
      {
        name: "run_firebase_emulators",
        description: "Start Firebase emulators for local testing",
        inputSchema: { type: "object", properties: {} }
      }
    ]
  };
});

// Execute tools
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name } = request.params;

  try {
    if (name === "flutter_pub_get") {
      const { stdout, stderr } = await execAsync("flutter pub get", { cwd: projectRoot });
      return { content: [{ type: "text", text: stdout || stderr }] };
    } 
    
    else if (name === "run_build_runner") {
      const { stdout, stderr } = await execAsync("dart run build_runner build --delete-conflicting-outputs", { cwd: projectRoot });
      return { content: [{ type: "text", text: stdout || stderr }] };
    } 
    
    else if (name === "wipe_hive_caches") {
      // Deletes the standard Hive application documents directory (if stored locally during dev)
      // Note: Actual paths depend on emulator/platform, this cleans web/desktop local temp directories if applicable
      const { stdout, stderr } = await execAsync("flutter clean", { cwd: projectRoot });
      return { content: [{ type: "text", text: `Cleaned Flutter and Hive build caches. \n${stdout}` }] };
    } 
    
    else if (name === "run_firebase_emulators") {
      // Runs the emulators in the background and returns status
      execAsync("firebase emulators:start", { cwd: projectRoot });
      return { content: [{ type: "text", text: "Firebase emulators started in the background." }] };
    }

    throw new Error(`Tool ${name} not recognized.`);
  } catch (error: any) {
    return {
      content: [{ type: "text", text: `Error executing ${name}: ${error.message}` }],
      isError: true
    };
  }
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("Ethioshop MCP Server running on stdio");
}

main().catch(console.error);
