# Contributing to EthioShop

Thank you for your interest in contributing to EthioShop, Ethiopia's premier e-commerce marketplace! We welcome contributions from developers, designers, and users who want to help improve the platform.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Submitting Pull Requests](#submitting-pull-requests)
- [Reporting Issues](#reporting-issues)

## Code of Conduct

We are committed to providing a welcoming and inclusive environment for all contributors. Please be respectful and constructive in all interactions.

## Getting Started

### Prerequisites

- Flutter 3.24.0 or higher
- Dart 3.5.0 or higher
- Android Studio / VS Code with Flutter extension
- Git

### Setting Up Development Environment

1. **Fork the repository**
   ```bash
   # Fork the repository on GitHub
   # Clone your fork locally
   git clone https://github.com/your-username/ethioshop.git
   cd ethioshop
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Using Nix (Optional)

For a reproducible development environment:

```bash
nix-shell
```

## Development Workflow

1. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-fix-name
   ```

2. **Make your changes**
   - Follow the coding standards
   - Write tests for new features
   - Update documentation

3. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

5. **Push and create a pull request**
   ```bash
   git push origin feature/your-feature-name
   ```

## Coding Standards

### Dart/Flutter Guidelines

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format` to format your code
- Use meaningful variable and function names
- Add documentation comments for public APIs
- Keep functions small and focused
- Use const constructors where possible

### File Organization

```
lib/
├── core/           # Core functionality (constants, utils, router)
├── data/           # Data layer (models, repositories, datasources)
├── domain/         # Domain layer (entities, repositories, usecases)
└── presentation/   # Presentation layer (screens, widgets, providers)
```

### Ethiopian-Specific Considerations

- Always use ETB currency format for prices
- Validate Ethiopian phone numbers (+251)
- Include all 13 Ethiopian regions in location selection
- Consider Ethiopian cultural contexts in UI/UX
- Use Amharic translations where appropriate

### Example Code

```dart
/// Fetches products from a specific Ethiopian region
Future<List<Product>> fetchProductsByRegion(String region) async {
  try {
    final products = await _productRepository.getProductsByRegion(region);
    return products;
  } catch (e) {
    throw ProductFetchException('Failed to fetch products: $e');
  }
}
```

## Testing Guidelines

### Unit Tests

- Test business logic in isolation
- Mock dependencies
- Use descriptive test names
- Test both success and failure cases

### Widget Tests

- Test widget rendering
- Test user interactions
- Test state changes
- Use mock providers

### Integration Tests

- Test complete user flows
- Test navigation
- Test real-world scenarios

### Test Coverage

- Aim for at least 80% code coverage
- Run tests before committing
- Ensure all tests pass

### Example Test

```dart
test('should display product price in ETB', () {
  final product = Product.fromJson(
    MockDataGenerators.generateMockProduct(price: 500.00),
  );
  
  expect(product.price, 500.00);
  expect(product.currency, 'ETB');
});
```

## Submitting Pull Requests

### PR Guidelines

- Keep PRs focused on a single feature or fix
- Write clear descriptions of changes
- Link related issues
- Ensure all tests pass
- Update documentation if needed

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe tests performed

## Checklist
- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] All tests passing
```

## Reporting Issues

### Bug Reports

When reporting a bug, include:

- Clear description of the problem
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots if applicable
- Environment details (OS, Flutter version, device)

### Feature Requests

When requesting a feature, include:

- Clear description of the feature
- Use cases and benefits
- Possible implementation approach
- Examples from other apps

## Getting Help

- Check existing documentation
- Search existing issues
- Ask in discussions
- Contact maintainers

## Recognition

Contributors will be acknowledged in:
- CONTRIBUTORS.md
- Release notes
- Project website

Thank you for contributing to EthioShop! 🇪🇹