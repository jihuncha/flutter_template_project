///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsKo = Translations; // ignore: unused_element

class Translations implements BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final t = Translations.of(context);
  static Translations of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(
         overrides == null,
         'Set "translation_overrides: true" in order to enable this feature.',
       ),
       $meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.ko,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           );

  /// Metadata for the translations of <ko>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => Translations(meta: meta ?? this.$meta);

  // Translations
  late final TranslationsHomeKo home = TranslationsHomeKo._(_root);
  late final TranslationsSettingsKo settings = TranslationsSettingsKo._(_root);
}

// Path: home
class TranslationsHomeKo {
  TranslationsHomeKo._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ko: '카운터'
  String get counter => '카운터';
}

// Path: settings
class TranslationsSettingsKo {
  TranslationsSettingsKo._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ko: '설정'
  String get title => '설정';

  /// ko: '언어'
  String get language => '언어';

  /// ko: '테마'
  String get theme => '테마';

  /// ko: '버전'
  String get version => '버전';

  /// ko: '라이선스'
  String get licenses => '라이선스';
}
