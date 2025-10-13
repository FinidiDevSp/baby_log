// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Baby Log';

  @override
  String get homeEditBabyTooltip => 'Editar bebé';

  @override
  String get homeEmptyDescription =>
      'Aquí aparecerán las métricas y registros de tu bebé.';

  @override
  String homeLoadError(Object error) {
    return 'No se pudo cargar la información del bebé.\n$error';
  }

  @override
  String get formEditTitle => 'Editar bebé';

  @override
  String get formCreateTitle => 'Registrar bebé';

  @override
  String get formGenderBoy => 'Niño';

  @override
  String get formGenderGirl => 'Niña';

  @override
  String get formGenderBoySemantic => 'Bebé niño';

  @override
  String get formGenderGirlSemantic => 'Bebé niña';

  @override
  String get formNameLabel => 'Nombre del bebé';

  @override
  String get formNameHint => 'Escribe el nombre';

  @override
  String get formNameError => 'El nombre es obligatorio';

  @override
  String get formBirthSection => 'Nacimiento';

  @override
  String get formBirthDateLabel => 'Fecha';

  @override
  String get formBirthDatePlaceholder => 'Selecciona la fecha';

  @override
  String get formBirthTimeLabel => 'Hora';

  @override
  String get formBirthTimePlaceholder => 'Selecciona la hora';

  @override
  String get formBirthDateHelp => 'Fecha de nacimiento';

  @override
  String get formBirthTimeHelp => 'Hora de nacimiento';

  @override
  String get formMeasurementsSection => 'Medidas al nacer';

  @override
  String get formWeightLabel => 'Peso (kg)';

  @override
  String get formWeightHint => 'Ej. 3.20';

  @override
  String get formHeightLabel => 'Altura (cm)';

  @override
  String get formHeightHint => 'Ej. 50.5';

  @override
  String get formInterfaceColorTitle => 'Color de la interfaz';

  @override
  String get formInterfaceColorSubtitle =>
      'Toca para elegir el color de acento.';

  @override
  String get formColorPickerTitle => 'Color de la interfaz';

  @override
  String get formColorPickerConfirm => 'De acuerdo';

  @override
  String get formSheetCloseTooltip => 'Cerrar';

  @override
  String get formSaveButton => 'Guardar';

  @override
  String get formPhotoSheetCamera => 'Tomar foto';

  @override
  String get formPhotoSheetGallery => 'Elegir de la galería';

  @override
  String formPhotoLoadError(Object error) {
    return 'No se pudo cargar la imagen: $error';
  }

  @override
  String get formBirthMissingError => 'Completa la fecha y hora de nacimiento.';

  @override
  String get formUpdateSuccess => 'Perfil actualizado.';

  @override
  String get formCreateSuccess => 'Perfil guardado.';

  @override
  String formSaveError(Object error) {
    return 'Error al guardar: $error';
  }

  @override
  String get dashboardBottleLabel => 'Biber?n';

  @override
  String get dashboardDiaperLabel => 'Caca';

  @override
  String get dashboardVomitLabel => 'V?mito';

  @override
  String get dashboardBathLabel => 'Ba?o';

  @override
  String get dashboardTemperatureLabel => 'Temperatura';

  @override
  String get dashboardFoodLabel => 'Comida';

  @override
  String get dashboardMedicalAgendaLabel => 'AGENDA';

  @override
  String get dashboardElapsedJustNow => 'Justo ahora';

  @override
  String dashboardElapsedMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count mins',
      one: 'Hace 1 min',
    );
    return '$_temp0';
  }

  @override
  String dashboardElapsedHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count h',
      one: 'Hace 1 h',
    );
    return '$_temp0';
  }

  @override
  String dashboardElapsedDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count días',
      one: 'Hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String get dashboardEventsEmptyTitle => 'No se encontr? informaci?n';

  @override
  String get dashboardNavHome => 'Inicio';

  @override
  String get dashboardNavStats => 'Estad?sticas';

  @override
  String get dashboardNavTimeline => 'L?nea temporal';

  @override
  String get dashboardNavDevelopment => 'Desarrollo';

  @override
  String get dashboardNavAccount => 'Cuenta';

  @override
  String get dashboardSearchTooltip => 'Buscar';

  @override
  String get dashboardNotificationsTooltip => 'Notificaciones';

  @override
  String get dashboardTodayLabel => 'Hoy';

  @override
  String get dashboardChangeDayTooltip => 'Cambiar día';

  @override
  String get dashboardImportTooltip => 'Importar datos';

  @override
  String get dashboardExportTooltip => 'Exportar datos';

  @override
  String get dashboardPediatricQuestionsLabel => 'Preguntas';

  @override
  String get bottleLogTitle => 'Toma de biberón';

  @override
  String get bottleLogDateTimeLabel => 'Día y hora';

  @override
  String get bottleLogAmountLabel => 'Cantidad';

  @override
  String get bottleLogAmountUnit => 'ml';

  @override
  String get bottleLogNotesLabel => 'Notas';

  @override
  String get bottleLogNotesHint => 'Añade detalles que quieras recordar';

  @override
  String get bottleLogAmountValidation => 'Introduce una cantidad válida';

  @override
  String get bottleLogDecreaseTooltip => 'Restar 5 ml';

  @override
  String get bottleLogIncreaseTooltip => 'Sumar 5 ml';

  @override
  String get homeLogListTitle => 'Últimos registros';

  @override
  String get bathLogTitle => 'Baño';

  @override
  String get bathLogTypeLabel => 'Tipo de baño';

  @override
  String get bathLogTypeFullOption => 'Completo';

  @override
  String get bathLogTypeQuickOption => 'Rápido';

  @override
  String get bathLogTypeFullDescription => 'Baño completo';

  @override
  String get bathLogTypeQuickDescription => 'Baño rápido';

  @override
  String get bathLogNotesLabel => 'Notas';

  @override
  String get bathLogNotesHint => 'Añade detalles que quieras recordar';

  @override
  String get stoolLogTitle => 'Cambio de pañal';

  @override
  String get stoolLogDateTimeLabel => 'Día y hora';

  @override
  String get stoolLogConsistencyLabel => 'Consistencia';

  @override
  String get stoolLogConsistencyLiquidOption => 'Líquida';

  @override
  String get stoolLogConsistencySoftOption => 'Blanda';

  @override
  String get stoolLogConsistencyFirmOption => 'Firme';

  @override
  String get stoolLogConsistencyLiquidDescription => 'Caca líquida';

  @override
  String get stoolLogConsistencySoftDescription => 'Caca blanda';

  @override
  String get stoolLogConsistencyFirmDescription => 'Caca firme';

  @override
  String get stoolLogNotesLabel => 'Notas';

  @override
  String get stoolLogNotesHint => 'Añade detalles que quieras recordar';

  @override
  String get stoolLogConsistencyValidation => 'Selecciona una consistencia';

  @override
  String get vomitLogTitle => 'Registro de vómito';

  @override
  String get vomitLogAmountLabel => 'Cantidad';

  @override
  String get vomitLogAmountLowOption => 'Poca';

  @override
  String get vomitLogAmountMediumOption => 'Media';

  @override
  String get vomitLogAmountHighOption => 'Abundante';

  @override
  String get vomitLogAmountLowDescription => 'Vómito ligero';

  @override
  String get vomitLogAmountMediumDescription => 'Vómito moderado';

  @override
  String get vomitLogAmountHighDescription => 'Vómito abundante';

  @override
  String get vomitLogNotesLabel => 'Notas';

  @override
  String get vomitLogNotesHint => 'Añade detalles que quieras recordar';

  @override
  String get vomitLogAmountValidation => 'Selecciona una cantidad';

  @override
  String get temperatureLogTitle => 'Temperatura';

  @override
  String get temperatureLogValueLabel => 'Temperatura';

  @override
  String get temperatureLogValueUnit => '°C';

  @override
  String get temperatureLogDecreaseTooltip => 'Restar 0,1 °C';

  @override
  String get temperatureLogIncreaseTooltip => 'Sumar 0,1 °C';

  @override
  String get temperatureLogValueValidation =>
      'Introduce una temperatura válida';

  @override
  String get temperatureLogNotesLabel => 'Notas';

  @override
  String get temperatureLogNotesHint => 'Añade detalles que quieras recordar';

  @override
  String get bottleLogListTitle => 'Últimas tomas';
}
