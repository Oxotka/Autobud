﻿
#Область ПрограммныйИнтерфейс

&НаСервере
// Возвращает сведения о внешней обработке.
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиПечатнаяФорма();
	ПараметрыРегистрации.Версия = "1.0";
	ПараметрыРегистрации.Назначение.Добавить("Документ.ЗаказКлиента");
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	
	// Заказ на сборку
	НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	НоваяКоманда.Представление = НСтр("ru = 'Заказ на сборку (без контроля и цен)'");
	НоваяКоманда.Идентификатор = "ЗаказКлиента";
	НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	НоваяКоманда.ПоказыватьОповещение = Истина;
	НоваяКоманда.Модификатор = "ПечатьMXL";
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

&НаСервере
// Интерфейс для выполнения команд обработки.
Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаказКлиента") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЗаказКлиента",
			НСтр("ru = 'Заказ на сборку (без контроля и цен)'"),
			ПечатьЗаказаКлиента(МассивОбъектов, ОбъектыПечати)
			);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПечатьЗаказаКлиента

&НаСервере
Функция ПечатьЗаказаКлиента(МассивОбъектов, ОбъектыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.ИмяПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказКлиента";
	
	НомерТипаДокумента = 0;
	
	Для Каждого Объект Из МассивОбъектов Цикл
			
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПараметрыПечати = Новый Структура;
		
		// Данные для массива объектов
		ДанныеДляПечати = Документы.ЗаказКлиента.ПолучитьДанныеДляПечатнойФормыЗаказаНаТоварыУслуги(
			Объект,
			ПараметрыПечати);
			
		// Сформированный тбаличный документ
		ЗаполнитьТабличныйДокументЗаказаНаТоварыУслуги(
			ТабличныйДокумент,
			ДанныеДляПечати,
			ОбъектыПечати,
			Неопределено,
			"ПФ_MXL_ЗаказКлиента");
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#Область ПечатьЗаказаПартнеруОтПартнераНаТоварыРаботыИлиУслуги

Процедура ЗаполнитьТабличныйДокументЗаказаНаТоварыУслуги(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, КомплектыПечати, ИмяМакета)
	
	ШаблонОшибкиТовары	= НСтр("ru = 'В документе %1 отсутствуют товары. Печать %2 не требуется'");
	ШаблонОшибкиЭтапы	= НСтр("ru = 'В документе %1 отсутствуют этапы оплаты. Печать %2 не требуется'");
	
	ИспользоватьРучныеСкидки			= ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах");
	ИспользоватьАвтоматическиеСкидки	= ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиВПродажах");
	
	ДанныеПечати	= ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ЭтапыОплаты		= ДанныеДляПечати.РезультатПоЭтапамОплаты.Выгрузить();
	Товары			= ДанныеДляПечати.РезультатПоТабличнойЧасти.Выгрузить();
	
	ПервыйДокумент	= Истина;
	КолонкаКодов	= ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
	ВыводитьКоды	= Не ПустаяСтрока(КолонкаКодов);
	
	Пока ДанныеПечати.Следующий() Цикл
		
		Макет = ПолучитьМакет(ИмяМакета);
		
		// Для печати комплектов
		Если КомплектыПечати <> Неопределено И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено Тогда
			
			КомплектПечатиПоСсылке = КомплектыПечати.Найти(ДанныеПечати.Ссылка, "Ссылка");
			
			Если КомплектПечатиПоСсылке = Неопределено Тогда
				КомплектПечатиПоСсылке = КомплектыПечати[0];
			КонецЕсли;
			
			Если КомплектПечатиПоСсылке.Экземпляров = 0 Тогда
				Продолжить
			КонецЕсли;
			
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		
		ТаблицаТовары = Товары.НайтиСтроки(СтруктураПоиска);
		
		Если ТаблицаТовары.Количество() = 0 Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонОшибкиТовары,
				ДанныеПечати.Ссылка,
				ДанныеПечати.ПредставлениеВОшибке);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ДанныеПечати.Ссылка);
			Продолжить;
			
		КонецЕсли;
		
		ТаблицаЭтапыОплаты = ЭтапыОплаты.НайтиСтроки(СтруктураПоиска);
		
		Если ПервыйДокумент Тогда
			ПервыйДокумент = Ложь;
		Иначе
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВыводитьВидЦены = Ложь;
		
		ЗаголовокСкидки	= ФормированиеПечатныхФорм.НужноВыводитьСкидки(ТаблицаТовары, ДанныеПечати.ИспользоватьАвтоСкидки);
		ЕстьСкидки		= Ложь;
		ПоказыватьНДС	= Ложь;
		
#Область ОпределениеИменЗаголовковОбластей
		
		ЕстьДопПараметр		= ЕстьСкидки Или ВыводитьВидЦены Или ПоказыватьНДС;
		ДвойнойДопПараметр	= (ЕстьСкидки И ВыводитьВидЦены) Или (ЕстьСкидки И ПоказыватьНДС);
		
		Если ДвойнойДопПараметр Тогда
			ПостфиксКолонок = "СДвумяПараметрами";
		ИначеЕсли ЕстьДопПараметр Тогда
			ПостфиксКолонок = "СОднимПараметром";
		Иначе
			ПостфиксКолонок = "";
		КонецЕсли;
		
		ОбластьКолонкаТовар = Макет.Область("Товар" + ПостфиксКолонок);
		
		Если Не ВыводитьКоды Тогда
			
			Если ДвойнойДопПараметр Тогда
				ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки * 1.35;
			ИначеЕсли ЕстьДопПараметр Тогда
				ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки * 1.2;
			Иначе
				ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки * 1.14;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЕстьСкидки И ВыводитьВидЦены Тогда
			ПостфиксСтрок = "СУсловиемСоСкидкой";
		ИначеЕсли ЕстьСкидки И ПоказыватьНДС Тогда
			ПостфиксСтрок = "СНДССоСкидкой";
		ИначеЕсли ПоказыватьНДС Тогда
			ПостфиксСтрок = "СНДС";
		ИначеЕсли ЕстьСкидки Тогда
			ПостфиксСтрок = "СоСкидкой";
		ИначеЕсли ВыводитьВидЦены Тогда
			ПостфиксСтрок = "СУсловием";
		Иначе
			ПостфиксСтрок = "";
		КонецЕсли;
		
#КонецОбласти
		
#Область ОбластиМакета
		
		// ОБЛАСТЕЙ ТАБЛИЦЫ "ТОВАРЫ"
		
		ОбластьНомераШапки		= Макет.ПолучитьОбласть("ШапкаТаблицы" + ПостфиксСтрок + "|НомерСтроки");
		ОбластьКодовШапки		= Макет.ПолучитьОбласть("ШапкаТаблицы" + ПостфиксСтрок + "|КолонкаКодов");
		ОбластьТоварШапки		= Макет.ПолучитьОбласть("ШапкаТаблицы" + ПостфиксСтрок + "|Товар"  + ПостфиксКолонок);
		ОбластьДанныхШапки		= Макет.ПолучитьОбласть("ШапкаТаблицы" + ПостфиксСтрок + "|Данные" + ПостфиксКолонок);
		
		ОбластьНомераСтрокиСтандарт = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "|НомерСтроки");
		ОбластьКодовСтрокиСтандарт  = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "|КолонкаКодов");
		ОбластьТоварСтрокиСтандарт  = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "|Товар"  + ПостфиксКолонок);
		ОбластьДанныхСтрокиСтандарт = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "|Данные" + ПостфиксКолонок);
		
		ИспользоватьНаборы = Ложь;
		Если Товары.Колонки.Найти("ЭтоНабор") <> Неопределено Тогда
			ИспользоватьНаборы = Истина;
			ОбластьНомераСтрокиНабор         = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Набор"         + "|НомерСтроки");
			ОбластьНомераСтрокиКомплектующие = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Комплектующие" + "|НомерСтроки");
			ОбластьКодовСтрокиНабор          = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Набор"         + "|КолонкаКодов");
			ОбластьКодовСтрокиКомплектующие  = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Комплектующие" + "|КолонкаКодов");
			ОбластьТоварСтрокиНабор          = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Набор"         + "|Товар"  + ПостфиксКолонок);
			ОбластьТоварСтрокиКомплектующие  = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Комплектующие" + "|Товар"  + ПостфиксКолонок);
			ОбластьДанныхСтрокиНабор         = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Набор"         + "|Данные" + ПостфиксКолонок);
			ОбластьДанныхСтрокиКомплектующие = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Комплектующие" + "|Данные" + ПостфиксКолонок);
		КонецЕсли;
		
		ОбластьНомераПодвала	= Макет.ПолучитьОбласть("ПодвалТаблицы" + ПостфиксСтрок + "|НомерСтроки");
		ОбластьКодовПодвала		= Макет.ПолучитьОбласть("ПодвалТаблицы" + ПостфиксСтрок + "|КолонкаКодов");
		ОбластьТоварПодвала		= Макет.ПолучитьОбласть("ПодвалТаблицы" + ПостфиксСтрок + "|Товар"  + ПостфиксКолонок);
		ОбластьДанныхПодвала	= Макет.ПолучитьОбласть("ПодвалТаблицы" + ПостфиксСтрок + "|Данные" + ПостфиксКолонок);
		
		ОбластьСуммаПрописью = Макет.ПолучитьОбласть("СуммаПрописью");
		ОбластьСпособДоставки = Макет.ПолучитьОбласть("СпособДоставки");
		
#КонецОбласти
		
#Область ВыводШапки
		
		// ШАПКА - ЗАГОЛОВОК
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ФормированиеПечатныхФорм.ВывестиЛоготипВТабличныйДокумент(Макет, ОбластьМакета, "Заголовок", ДанныеПечати.Организация);
		
		УстановитьПараметр(ОбластьМакета, "ТекстЗаголовка", ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(
			ДанныеПечати,
			"Заказ на сборку"));
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(
			ТабличныйДокумент,
			Макет,
			ОбластьМакета,
			ДанныеПечати.Ссылка);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// ШАПКА - ИСПОЛНИТЕЛЬ
		
		ОбластьМакета = Макет.ПолучитьОбласть("Исполнитель");
		УстановитьПараметр(ОбластьМакета, "ПредставлениеИсполнителя", ОписаниеОрганизации(ДанныеПечати, "Исполнитель"));
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// ШАПКА - ЗАКАЗЧИК
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заказчик");
		УстановитьПараметр(ОбластьМакета, "ПредставлениеЗаказчика", ОписаниеОрганизации(ДанныеПечати, "Заказчик"));
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// ШАПКА - ГРУЗООТПРАВИТЕЛЬ
		
		Если ЗначениеЗаполнено(ДанныеПечати.Грузоотправитель) Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("Грузоотправитель");
			УстановитьПараметр(ОбластьМакета, "ПредставлениеГрузоотправителя", ОписаниеОрганизации(ДанныеПечати, "Грузоотправитель"));
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		// ШАПКА - ГРУЗОПОЛУЧАТЕЛЬ
		
		Если ЗначениеЗаполнено(ДанныеПечати.Грузополучатель) Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("Грузополучатель");
			УстановитьПараметр(ОбластьМакета, "ПредставлениеГрузополучателя", ОписаниеОрганизации(ДанныеПечати, "Грузополучатель"));
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		// ШАПКА - АДРЕС ДОСТАВКИ
		
		Если ЗначениеЗаполнено(ДанныеПечати.АдресДоставки) Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("АдресДоставки");
			УстановитьПараметр(ОбластьМакета, "АдресДоставки", ДанныеПечати.АдресДоставки);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
#КонецОбласти
		
#Область ВыводТаблицыТовары
		
		// ТАБЛИЦА ТОВАРЫ - ШАПКА
		
		Если ЕстьСкидки Тогда
			УстановитьПараметр(ОбластьДанныхШапки, "Скидка", ЗаголовокСкидки.Скидка);
			УстановитьПараметр(ОбластьДанныхШапки, "СуммаБезСкидки", ЗаголовокСкидки.СуммаСкидки);
		КонецЕсли; 
		
		Если ВыводитьКоды Тогда
			УстановитьПараметр(ОбластьКодовШапки, "ИмяКолонкиКодов", КолонкаКодов);
		КонецЕсли;
		
		// ТАБЛИЦА ТОВАРЫ - СТРОКИ
		
		МассивПроверкиВывода = Новый Массив;
		МассивПроверкиВывода.Добавить(ОбластьНомераШапки);
		МассивПроверкиВывода.Добавить(ОбластьНомераПодвала);
		МассивПроверкиВывода.Добавить(ОбластьСуммаПрописью);
		
		Сумма			= 0;
		Количество		= 0;
		СуммаНДС		= 0;
		ВсегоСкидок		= 0;
		ВсегоБезСкидок	= 0;
		
		НомерСтроки = 0;
		
		ПустыеДанные = НаборыСервер.ПустыеДанные();
		ВыводШапки = 0;
		
		СоответствиеСтавокНДС = Новый Соответствие;
		
		Для Каждого СтрокаТовары Из ТаблицаТовары Цикл
			
			Если НаборыСервер.ИспользоватьОбластьНабор(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьКодовСтроки   = ОбластьКодовСтрокиНабор;
				ОбластьНомераСтроки  = ОбластьНомераСтрокиНабор;
				ОбластьДанныхСтроки  = ОбластьДанныхСтрокиНабор;
				ОбластьТоварСтроки   = ОбластьТоварСтрокиНабор;
			ИначеЕсли НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьКодовСтроки   = ОбластьКодовСтрокиКомплектующие;
				ОбластьНомераСтроки  = ОбластьНомераСтрокиКомплектующие;
				ОбластьДанныхСтроки  = ОбластьДанныхСтрокиКомплектующие;
				ОбластьТоварСтроки   = ОбластьТоварСтрокиКомплектующие;
			Иначе
				ОбластьКодовСтроки   = ОбластьКодовСтрокиСтандарт;
				ОбластьНомераСтроки  = ОбластьНомераСтрокиСтандарт;
				ОбластьДанныхСтроки  = ОбластьДанныхСтрокиСтандарт;
				ОбластьТоварСтроки   = ОбластьТоварСтрокиСтандарт;
			КонецЕсли;
			
			Если НаборыСервер.ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Тогда
				УстановитьПараметр(ОбластьНомераСтроки, "НомерСтроки", Неопределено);
			Иначе
				НомерСтроки = НомерСтроки + 1;
				УстановитьПараметр(ОбластьНомераСтроки, "НомерСтроки", НомерСтроки);
			КонецЕсли;
			
			Если НомерСтроки = 0 И ВыводШапки <> 2 Тогда
				ВыводШапки = 1;
			КонецЕсли;
			
			МассивПроверкиВывода.Добавить(ОбластьНомераСтроки);
			
			Если ТабличныйДокумент.ПроверитьВывод(МассивПроверкиВывода) Тогда
				
				Если (НомерСтроки = 1 И ВыводШапки = 0) ИЛИ (НомерСтроки = 0 И ВыводШапки = 1) Тогда
					
					ВыводШапки = 2;
					
					ВывестиШапку(ТабличныйДокумент, ОбластьНомераШапки, ОбластьКодовШапки, ОбластьТоварШапки, ОбластьДанныхШапки, ВыводитьКоды);
					МассивПроверкиВывода.Удалить(0);
					
				КонецЕслИ;
				
			Иначе
				
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ВывестиШапку(ТабличныйДокумент, ОбластьНомераШапки, ОбластьКодовШапки, ОбластьТоварШапки, ОбластьДанныхШапки, ВыводитьКоды);
				
			КонецЕсли;
			
			МассивПроверкиВывода.Удалить(МассивПроверкиВывода.ВГраница());
			
			УстановитьПараметр(ОбластьНомераСтроки, "НомерСтроки", НомерСтроки);
			ТабличныйДокумент.Вывести(ОбластьНомераСтроки);
			
			Если ВыводитьКоды Тогда
				
				ИмяКолонки = КолонкаКодов;
				Если ДанныеПечати.Тип = "ЗаказПоставщикуПоДаннымПоставщика" Тогда
					ИмяКолонки = ИмяКолонки + "Исполнителя";
				КонецЕсли;
				
				УстановитьПараметр(ОбластьКодовСтроки, "Артикул", СтрокаТовары[ИмяКолонки]);
				ТабличныйДокумент.Присоединить(ОбластьКодовСтроки);
				
			КонецЕсли;
			
			Если ДанныеПечати.Тип = "ЗаказПоставщикуПоДаннымПоставщика" Тогда
				
				ПредставлениеНоменклатурыДляПечати = СтрокаТовары.НаименованиеНоменклатурыИсполнителя;
				
			Иначе
				
				ДополнительныеПараметрыПолученияНаименованияДляПечати = НоменклатураКлиентСервер.ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати();
				ДополнительныеПараметрыПолученияНаименованияДляПечати.ВозвратнаяТара = СтрокаТовары.ЭтоВозвратнаяТара;				
				ДополнительныеПараметрыПолученияНаименованияДляПечати.Содержание = СтрокаТовары.Содержание;				
				
				ПредставлениеНоменклатурыДляПечати = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
					СтрокаТовары.НаименованиеПолное,
					СтрокаТовары.Характеристика,
					,
					,
					ДополнительныеПараметрыПолученияНаименованияДляПечати);
				
			КонецЕсли;
			
			ПрефиксИПостфикс = НаборыСервер.ПолучитьПрефиксИПостфикс(СтрокаТовары, ИспользоватьНаборы);
			УстановитьПараметр(ОбластьТоварСтроки, "Товар", ПрефиксИПостфикс.Префикс + ПредставлениеНоменклатурыДляПечати + ПрефиксИПостфикс.Постфикс);
			
			ТабличныйДокумент.Присоединить(ОбластьТоварСтроки);
			ОбластьДанныхСтроки.Параметры.Заполнить(СтрокаТовары);
			
			Если ЗаголовокСкидки.ЕстьСкидки Тогда
				УстановитьПараметр(ОбластьДанныхСтроки, "СуммаСкидки", ?(ЗаголовокСкидки.ТолькоНаценка, - СтрокаТовары.СуммаСкидки, СтрокаТовары.СуммаСкидки));
			КонецЕсли;
			
			Если НаборыСервер.ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьДанныхСтроки.Параметры.Заполнить(ПустыеДанные);
			Иначе
				ОбластьДанныхСтроки.Параметры.Заполнить(СтрокаТовары);
			КонецЕсли;
			
			ТабличныйДокумент.Присоединить(ОбластьДанныхСтроки);
			
			Если Не НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				Сумма    = Сумма    + СтрокаТовары.Сумма;
				СуммаНДС = СуммаНДС + СтрокаТовары.СуммаНДС;
				Количество = Количество + СтрокаТовары.Количество;
				
				Если ЕстьСкидки Тогда
					ВсегоСкидок    = ВсегоСкидок    + СтрокаТовары.СуммаСкидки;
					ВсегоБезСкидок = ВсегоБезСкидок + СтрокаТовары.СуммаБезСкидки;
				КонецЕсли;
			
				Если ДанныеПечати.УчитыватьНДС Тогда
					
					СуммаНДСПоСтавке = СоответствиеСтавокНДС[СтрокаТовары.СтавкаНДС];
					
					Если СуммаНДСПоСтавке = Неопределено Тогда
						СуммаНДСПоСтавке = 0;
					КонецЕсли;
					
					СоответствиеСтавокНДС.Вставить(СтрокаТовары.СтавкаНДС, СуммаНДСПоСтавке + СтрокаТовары.СуммаНДС);
					
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		// ТАБЛИЦА ТОВАРЫ - ПОДВАЛ
		
		ТабличныйДокумент.Вывести(ОбластьНомераПодвала);
		
		Если ВыводитьКоды Тогда
			ТабличныйДокумент.Присоединить(ОбластьКодовПодвала);
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьТоварПодвала);
		
		Если ЕстьСкидки Тогда
			УстановитьПараметр(ОбластьДанныхПодвала, "ВсегоСкидок", ?(ЗаголовокСкидки.ТолькоНаценка, -ВсегоСкидок, ВсегоСкидок));
			УстановитьПараметр(ОбластьДанныхПодвала, "ВсегоБезСкидок", ВсегоБезСкидок);
		КонецЕсли;
		
		УстановитьПараметр(ОбластьДанныхПодвала, "Всего", Количество);
		ТабличныйДокумент.Присоединить(ОбластьДанныхПодвала);
		
#КонецОбласти
		
#Область ВыводПодвала
		
		// ПОДВАЛ - СУММА ПРОПИСЬЮ
		
		ТекстИтоговойСтроки = НСтр("ru='Всего наименований %1, количество %2'");
		
		ИтоговаяСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстИтоговойСтроки,
			НомерСтроки, // Количество наименований
			Количество); // Количество товара
		
		УстановитьПараметр(ОбластьСуммаПрописью, "ИтоговаяСтрока", ИтоговаяСтрока);
		
		ТабличныйДокумент.Вывести(ОбластьСуммаПрописью);
		
		// ПОДВАЛ - ЭТАПЫ ГРАФИКА ОПЛАТЫ
		
		Если ТаблицаЭтапыОплаты.Количество() > 1 Тогда
			
			ОбластьШапкиТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицыЭтапыОплаты");
			ОбластьПодвалаТаблицы = Макет.ПолучитьОбласть("ИтогоЭтапыОплаты");
			
			МассивПроверкиВывода.Очистить();
			МассивПроверкиВывода.Добавить(ОбластьШапкиТаблицы);
			МассивПроверкиВывода.Добавить(ОбластьПодвалаТаблицы);
			
			ОбластьСтрокиТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицыЭтапыОплаты");
			
			НомерЭтапа = 1;
			Для Каждого ТекЭтап Из ТаблицаЭтапыОплаты Цикл
				
				ПараметрыСтроки = НовыеПараметрыСтрокиЭтапа();
				ЗаполнитьЗначенияСвойств(ПараметрыСтроки, ТекЭтап);
				ПараметрыСтроки.НомерСтроки = НомерЭтапа;
				Если Не ПараметрыСтроки.ЭтоЗалогЗаТару Тогда
					ПараметрыСтроки.ТекстНДС = ФормированиеПечатныхФорм.СформироватьТекстНДСЭтапаОплаты(
						СоответствиеСтавокНДС,
						ТекЭтап.ПроцентПлатежа);
				Иначе
					ПараметрыСтроки.ВариантОплаты = Строка(ТекЭтап.ВариантОплаты) + " " + НСтр("ru='(залог за тару)'");
					ПараметрыСтроки.ПроцентПлатежа = "-";
					ПараметрыСтроки.ТекстНДС = НСтр("ru='Без налога (НДС)'");
				КонецЕсли;
				
				ОбластьСтрокиТаблицы.Параметры.Заполнить(ПараметрыСтроки);
				
				МассивПроверкиВывода.Добавить(ОбластьСтрокиТаблицы);
				
				Если ТабличныйДокумент.ПроверитьВывод(МассивПроверкиВывода) Тогда
					
					Если НомерЭтапа=1 Тогда
						ТабличныйДокумент.Вывести(ОбластьШапкиТаблицы);
						МассивПроверкиВывода.Удалить(0);
					КонецЕслИ;
					
				Иначе
					
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ТабличныйДокумент.Вывести(ОбластьШапкиТаблицы);
					
				КонецЕсли;
				
				МассивПроверкиВывода.Удалить(МассивПроверкиВывода.ВГраница());
				
				ТабличныйДокумент.Вывести(ОбластьСтрокиТаблицы);
				
				НомерЭтапа = НомерЭтапа + 1;
				
			КонецЦикла;
			
			ТабличныйДокумент.Вывести(ОбластьПодвалаТаблицы);
			
		КонецЕсли;
		
		// ПОДВАЛ - ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ
		
		Если ЗначениеЗаполнено(ДанныеПечати.ДополнительнаяИнформация) Тогда
			
			ОбластьМакета = Макет.ПолучитьОбласть("ДополнительнаяИнформация");
			ДополнительнаяИнформация = ДанныеПечати.ДополнительнаяИнформация;
			Комментарий = ДанныеПечати.Ссылка.Комментарий;
			Если НЕ ПустаяСтрока(Комментарий) Тогда
				ДополнительнаяИнформация = ДополнительнаяИнформация + Символы.ПС + Комментарий;
			КонецЕсли;
			
			УстановитьПараметр(ОбластьМакета, "ДополнительнаяИнформация", ДополнительнаяИнформация);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
		// ПОДВАЛ - ПОДПИСИ
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалЗаказа");
		УстановитьПараметр(ОбластьМакета, "ФИОМенеджер", ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ДанныеПечати.Менеджер, ДанныеПечати.Дата));
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
#КонецОбласти

#Область ВыводСпособДоставки

		// Способ доставки
		ДополнительныеРеквизитыДляПечатнойФормы = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеПечати.Ссылка, "СпособДоставки, АдресДоставки, ДополнительнаяИнформацияПоДоставке");
		ОбластьСпособДоставки.Параметры.Заполнить(ДополнительныеРеквизитыДляПечатнойФормы);
		ТабличныйДокумент.Вывести(ОбластьСпособДоставки);
	
#КонецОбласти
		
		// Выведем нужное количество экземпляров (при печати комплектов)
		Если КомплектыПечати <> Неопределено
			И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено
			И КомплектПечатиПоСсылке.Экземпляров > 1 Тогда
			
			ОбластьКопирования = ТабличныйДокумент.ПолучитьОбласть(
				НомерСтрокиНачало,
				,
				ТабличныйДокумент.ВысотаТаблицы);
			
			Для Итератор = 2 По КомплектПечатиПоСсылке.Экземпляров Цикл
				
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьКопирования);
				
			КонецЦикла;
			
		КонецЕсли;
		
		//УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
		//	ТабличныйДокумент,
		//	НомерСтрокиНачало,
		//	ОбъектыПечати,
		//	ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

// Прочее

Процедура УстановитьПараметр(ОбластьМакета, ИмяПараметра, ЗначениеПараметра)
	ОбластьМакета.Параметры.Заполнить(Новый Структура(ИмяПараметра, ЗначениеПараметра));
КонецПроцедуры

Функция ОписаниеОрганизации(ДанныеПечати, ИмяОрганизации)
	
	Сведения = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати[ИмяОрганизации], ДанныеПечати.Дата);
	Реквизиты = "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,";
	
	Возврат ФормированиеПечатныхФорм.ОписаниеОрганизации(Сведения, Реквизиты);
	
КонецФункции

Процедура ВывестиШапку(ТабличныйДокумент, ОбластьНомераШапки, ОбластьКодовШапки, ОбластьТоварШапки, ОбластьДанныхШапки, ВыводитьКоды)
	
	ТабличныйДокумент.Вывести(ОбластьНомераШапки);
	Если ВыводитьКоды Тогда
		ТабличныйДокумент.Присоединить(ОбластьКодовШапки);
	КонецЕсли;
	ТабличныйДокумент.Присоединить(ОбластьТоварШапки);
	ТабличныйДокумент.Присоединить(ОбластьДанныхШапки);
	
КонецПроцедуры

Функция НовыеПараметрыСтрокиЭтапа()
	
	СтруктураСтрокиЭтапа = Новый Структура;
	СтруктураСтрокиЭтапа.Вставить("НомерСтроки", 0);
	СтруктураСтрокиЭтапа.Вставить("ВариантОплаты", "");
	СтруктураСтрокиЭтапа.Вставить("ДатаПлатежа", '00010101');
	СтруктураСтрокиЭтапа.Вставить("ПроцентПлатежа", 0);
	СтруктураСтрокиЭтапа.Вставить("СуммаПлатежа", 0);
	СтруктураСтрокиЭтапа.Вставить("ТекстНДС", "");
	СтруктураСтрокиЭтапа.Вставить("ЭтоЗалогЗаТару", Ложь);
	
	Возврат СтруктураСтрокиЭтапа;
	
КонецФункции

#КонецОбласти


#КонецОбласти
