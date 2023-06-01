
/// Representa un elemento de una lista expandible.
class Item {
  /// El contenido expandido del elemento.
  final String expanded;

  /// El título del elemento.
  final String title;

  /// Indica si el elemento está expandido o no.
  bool? isExpanded;

  /// Constructor de la clase [Item].
  ///
  /// - Parámetro [expanded]: El contenido expandido del elemento.
  /// - Parámetro [title]: El título del elemento.
  /// - Parámetro [isExpanded]: Indica si el elemento está expandido. (Opcional)
  Item({
    required this.expanded,
    required this.title,
    this.isExpanded,
  });
}