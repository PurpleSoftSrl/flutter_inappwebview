import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor2.dart';

class ModelVisitor extends SimpleElementVisitor2<void> {
  ConstructorElement? _constructor;

  ConstructorElement get constructor => _constructor!;

  final constructorParameters = <String, FormalParameterElement>{};
  final fields = <String, FieldElement>{};
  final methods = <String, MethodElement>{};

  @override
  void visitConstructorElement(ConstructorElement element) {
    _constructor = element;
    for (final param in element.formalParameters) {
      final name = param.name;
      if (name != null) {
        constructorParameters.putIfAbsent(name, () => param);
      }
    }
  }

  @override
  void visitFieldElement(FieldElement element) {
    final name = element.name;
    if (name != null) {
      fields[name] = element;
    }
  }

  @override
  void visitMethodElement(MethodElement element) {
    final name = element.name;
    if (name != null) {
      methods[name] = element;
    }
  }
}

/// Visits all the children of [element] with [visitor].
///
/// The constructors of an [InterfaceElement] are not part of its
/// [Element.children] anymore, so they are visited explicitly, after all the
/// other children.
void visitChildrenIncludingConstructors(
  Element element,
  ModelVisitor visitor,
) {
  element.visitChildren(visitor);
  if (element is InterfaceElement) {
    for (final constructor in element.constructors) {
      constructor.accept(visitor);
    }
  }
}
