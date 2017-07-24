﻿
&НаКлиенте
Процедура ПоказатьПредупреждениеУниверсальное(ТекстСообщения)
	Если ЭтоПлатформа82 Или РежимСовместимости82 ИЛИ ИспользованиеМодальности Тогда
		Выполнить("Предупреждение(ТекстСообщения)");
	Иначе
		Выполнить("ПоказатьПредупреждение(, ТекстСообщения)");
	КонецЕсли; 
КонецПроцедуры //ПоказатьПредупреждениеУниверсальное

&НаКлиенте
Процедура ПоказатьЗначениеУниверсальное(СсылкаНаОбъект)
	Если ЭтоПлатформа82 Или РежимСовместимости82 ИЛИ ИспользованиеМодальности Тогда
		Выполнить("ОткрытьЗначение(СсылкаНаОбъект)");
	Иначе
		Выполнить("ПоказатьЗначение(, СсылкаНаОбъект)");
	КонецЕсли; 
КонецПроцедуры //

&НаСервере
Функция ЗаполнитьПараметрыЗапроса()
	Если ПустаяСтрока(ТекстПроизвольногоЗапроса) Тогда
		Возврат "Отсутствует текст запроса.";
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстПроизвольногоЗапроса);
	Попытка
		ПараметрыВЗапросе = Запрос.НайтиПараметры();
	Исключение
		Возврат ОписаниеОшибки();
	КонецПопытки;
	
	Для каждого ПараметрЗапроса Из ПараметрыВЗапросе Цикл
		ИмяПараметра =  ПараметрЗапроса.Имя;
		СтрокаПараметров = ПараметрыЗапроса.НайтиСтроки(Новый Структура("ИмяПараметра", ИмяПараметра));
		Если  СтрокаПараметров.Количество() = 0 Тогда
			СтрокаПараметров = ПараметрыЗапроса.Добавить();
			СтрокаПараметров.ИмяПараметра = ИмяПараметра;
		Иначе 
			СтрокаПараметров = СтрокаПараметров[0];
		КонецЕсли; 
		Если СтрокаПараметров.ИмяПараметра = "УзелОбмена" Тогда
			СтрокаПараметров.ЗначениеПараметра = УзелОбмена;
		КонецЕсли; 
		
		СтрокаПараметров.ЗначениеПараметра = ПараметрЗапроса.ТипЗначения.ПривестиЗначение(СтрокаПараметров.ЗначениеПараметра);
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоДокумент(ПолноеИмяМетаданных)
	МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);
	Возврат Метаданные.Документы.Содержит(МетаданныеОбъекта);
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоРегистр(ПолноеИмяМетаданных)
	МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);
	Если Метаданные.РегистрыНакопления.Содержит(МетаданныеОбъекта) 
		ИЛИ Метаданные.РегистрыБухгалтерии.Содержит(МетаданныеОбъекта)
		ИЛИ Метаданные.РегистрыРасчета.Содержит(МетаданныеОбъекта) Тогда
		Возврат Истина;
	ИначеЕсли Метаданные.РегистрыСведений.Содержит(МетаданныеОбъекта) 
		И МетаданныеОбъекта.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
		Возврат Истина;
	КонецЕсли;  //  
	Возврат Ложь;
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоНезависимыйРегистр(ПолноеИмяМетаданных)
	Если ТипЗнч(ПолноеИмяМетаданных) = Тип("Строка") Тогда
		МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);
	Иначе
		МетаданныеОбъекта = ПолноеИмяМетаданных;
	КонецЕсли; 
	Если Метаданные.РегистрыСведений.Содержит(МетаданныеОбъекта) Тогда
		Возврат (МетаданныеОбъекта.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый)
	КонецЕсли; 
	Возврат Ложь;
КонецФункции

&НаСервере
Функция ВыполнитьЗапрос()
	ТаблицаСсылок.Очистить();
	
	Если РежимОтбора = 0 Тогда
		
		Попытка
			НастройкиСКД = ОтборДанных.ПолучитьНастройки();
			НастройкиСКД.Порядок.Элементы.Очистить();
			ПолеДата = Новый ПолеКомпоновкиДанных("Дата");
			Если НастройкиСКД.ДоступныеПоляПорядка.НайтиПоле(ПолеДата) <> Неопределено Тогда
				НовыйПорядок = НастройкиСКД.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
				НовыйПорядок.Использование = Истина;
				НовыйПорядок.Поле = ПолеДата;
				НовыйПорядок.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
			КонецЕсли; 
			
			СхемаКомпоновки = ПолучитьИзВременногоХранилища(АдресСхемы);
			// Подготовка компоновщика макета компоновки данных.
			КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
			МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновки, НастройкиСКД,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));

			ПроцессорКД = Новый ПроцессорКомпоновкиДанных;
			ПроцессорКД.Инициализировать(МакетКомпоновки);
			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
			ТаблицаРезультата = Новый ТаблицаЗначений;
			ПроцессорВывода.УстановитьОбъект(ТаблицаРезультата);
			ПроцессорВывода.Вывести(ПроцессорКД);
		Исключение
			Возврат ОписаниеОшибки();
		КонецПопытки;
		
	Иначе                  
		
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстПроизвольногоЗапроса;
		Если Удалить Тогда
			Запрос.УстановитьПараметр("УзелОбмена", УзелОбмена);
		КонецЕсли; 
		
		Для Каждого СтрокаПараметров Из ПараметрыЗапроса Цикл
			Если СтрокаПараметров.ЭтоВыражение Тогда
				Запрос.УстановитьПараметр(СтрокаПараметров.ИмяПараметра, Вычислить(СтрокаПараметров.ЗначениеПараметра));
			Иначе
				Запрос.УстановитьПараметр(СтрокаПараметров.ИмяПараметра, СтрокаПараметров.ЗначениеПараметра);
			КонецЕсли;
		КонецЦикла;
		
		Попытка
			ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
		Исключение
			Возврат ОписаниеОшибки();
		КонецПопытки;
		
	КонецЕсли;  //  
	
	Если ТаблицаРезультата.Колонки.Найти("Ссылка") = Неопределено Тогда
		Возврат "Не найдено поле ""Ссылка""!";
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы ИЗ ТаблицаРезультата Цикл
		НоваяСтрока = ТаблицаСсылок.Добавить();
		НоваяСтрока.Ссылка = СтрокаТаблицы.Ссылка;
		НоваяСтрока.Выбрать = Истина;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

// Добавляет отбор в набор отборов компоновщика или группы отборов
//
&НаСервереБезКонтекста
Функция ДобавитьОтбор(ЭлементСтруктуры, Знач Поле, Значение, ВидСравнения = Неопределено, Использование = Истина) Экспорт
	
	Если ТипЗнч(Поле) = Тип("Строка") Тогда
		Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЕсли;
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Настройки.Отбор;
	Иначе
		Отбор = ЭлементСтруктуры;
	КонецЕсли;
	
	Если ВидСравнения = Неопределено Тогда
		ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
	НовыйЭлемент = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйЭлемент.Использование  = Использование;
	НовыйЭлемент.ЛевоеЗначение  = Поле;
	НовыйЭлемент.ВидСравнения   = ВидСравнения;
	НовыйЭлемент.ПравоеЗначение = Значение;
	Возврат НовыйЭлемент;
	
КонецФункции

// Формирует текст запроса для отбора объекта
//
&НаСервереБезКонтекста
Функция СформироватьТекстЗапроса(Знач ИмяТаблицыДанных, ДляИзменения, ПереданныйОбъект, ДляСКД = Ложь)
	
	Перем ТекстЗапроса;
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ИмяТаблицыДанных);
	ИмяТаблицыДанных = ИмяТаблицыДанных + ?(ДляИзменения, ".Изменения", "");
	
	ТипUID = Тип("УникальныйИдентификатор");
	ТипХранилище = Тип("ХранилищеЗначения");
	
	ТекстЗапроса = 
		"ВЫБРАТЬ 
		|	ТаблицаСсылок.Ссылка КАК Ссылка";
		
	Если (ПереданныйОбъект = "Документ" ИЛИ ПереданныйОбъект = "Регистр") Тогда
		ТекстЗапроса = ТекстЗапроса + ",
		|	ТаблицаСсылок.Ссылка.Дата КАК Дата";
	КонецЕсли; 
	
	Если ПереданныйОбъект <> "Регистр" Тогда
		Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
			Если НЕ Реквизит.Тип.СодержитТип(ТипХранилище) И НЕ Реквизит.Тип.СодержитТип(ТипUID) Тогда
				ТекстЗапроса = ТекстЗапроса + ",
				|	ТаблицаСсылок." + ?(ДляИзменения, "Ссылка.", "") + Реквизит.Имя;
			КонецЕсли;
			Если Реквизит.Тип.Типы().Количество() > 1 Тогда
				ТекстЗапроса = ТекстЗапроса + ",
				|	ТИПЗНАЧЕНИЯ(ТаблицаСсылок." + ?(ДляИзменения, "Ссылка.", "") + Реквизит.Имя + ") КАК ТипПоля" + Реквизит.Имя;
			КонецЕсли; 
		КонецЦикла;
	ИначеЕсли ДляИзменения И ЭтоНезависимыйРегистр(ОбъектМетаданных) Тогда
		Для Каждого Реквизит Из ОбъектМетаданных.Измерения Цикл
			ТекстЗапроса = ТекстЗапроса + ",
			|	ТаблицаСсылок." + Реквизит.Имя;
			Если Реквизит.Тип.Типы().Количество() > 1 Тогда
				ТекстЗапроса = ТекстЗапроса + ",
				|	ТИПЗНАЧЕНИЯ(ТаблицаСсылок." + Реквизит.Имя + ") КАК ТипПоля" + Реквизит.Имя;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	
	ТекстЗапроса = ТекстЗапроса +  
		"
		|ИЗ
		|	" + ИмяТаблицыДанных + " КАК ТаблицаСсылок";
	
	Если ДляИзменения Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|ГДЕ
		|	ТаблицаСсылок.Узел = &УзелОбмена";
	КонецЕсли; 
	
	Если (ПереданныйОбъект = "Документ" ИЛИ ПереданныйОбъект = "Регистр") И ДляИзменения Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И
		|	ТаблицаСсылок.Ссылка.Дата МЕЖДУ &НачДата И &КонДата";
	ИначеЕсли (ПереданныйОбъект = "Документ" ИЛИ ПереданныйОбъект = "Регистр") И НЕ ДляИзменения Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|ГДЕ
		|	ТаблицаСсылок.Ссылка.Дата МЕЖДУ &НачДата И &КонДата";
	КонецЕсли; 
	
	Если (ПереданныйОбъект = "Документ" ИЛИ ПереданныйОбъект = "Регистр") Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|УПОРЯДОЧИТЬ ПО
		|	Дата ВОЗР";
	КонецЕсли; 
	
	Если ПереданныйОбъект = "Регистр" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ".Ссылка", ".Регистратор")
	КонецЕсли; 
	
	Возврат ТекстЗапроса;
	
КонецФункции

//Служебная
//
&НаСервереБезКонтекста
Процедура ПолучитьРеквизитыОбъектаМД_Итерация(Коллекция, Результат)
	
	ТипХранилище = Тип("ХранилищеЗначения");
	ТипUID = Тип("УникальныйИдентификатор");
	
	Для Каждого ЭлементКоллекции Из Коллекция Цикл
		Если ЭлементКоллекции.Имя = "Ссылка" 
			ИЛИ ЭлементКоллекции.Тип.СодержитТип(ТипХранилище) ИЛИ ЭлементКоллекции.Тип.СодержитТип(ТипUID) Тогда
			Продолжить;
		КонецЕсли; 
		Результат.Добавить(ЭлементКоллекции.Имя);
	КонецЦикла;	
	
КонецПроцедуры

//Служебная
//
&НаСервереБезКонтекста
Функция ПолучитьРеквизитыОбъектаМД(ОбъектМД)
	
	//	Сперва пробегаемся по всем реквизитам объекта метаданных
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ОбъектМД);
	
	Если ОбъектМетаданных <> Неопределено Тогда
		
		Результат = Новый СписокЗначений();
		ПолучитьРеквизитыОбъектаМД_Итерация(ОбъектМетаданных.СтандартныеРеквизиты, Результат);
		ПолучитьРеквизитыОбъектаМД_Итерация(ОбъектМетаданных.Реквизиты, Результат);
					
		Возврат Результат;
				
	Иначе
		Возврат Неопределено;
	КонецЕсли;
		
КонецФункции

//Служебная.
//На выходе получает список значений, содержащий только реквизиты, 
//присутствующие только в обоих входных списках значений
//
&НаСервереБезКонтекста
Функция ОтфильтроватьРеквизитыОбъектовМД(Список1, Список2)
	
	Если Список1.Количество() > 0 Тогда
		Если Список2.Количество() > 0 Тогда
			//	Сравнение имеет смысл только тогда, когда оба входных списка значений заполнены
			Результат = Новый СписокЗначений();
			Для Каждого ЭлементСпискаЗначений Из Список1 Цикл
				// Ищем соответствие в Список2
				текСоответствие = Список2.НайтиПоЗначению(ЭлементСпискаЗначений.Значение);
				Если текСоответствие <> Неопределено Тогда
					Результат.Добавить(ЭлементСпискаЗначений.Значение);
				КонецЕсли;
			КонецЦикла;
			Возврат Результат;
		Иначе
			Возврат Список1;
		КонецЕсли;
	Иначе
		Возврат Список2;
	КонецЕсли;
		
КонецФункции

//Получает список реквизитов, одинаковых для переданных объектов метаданных.
//Выдрано из конфигурации АС Экспертиза. Денис, привет!
//
// Возвращаемое значение:
//	СписокЗначений
//
&НаСервереБезКонтекста
Функция ПолучитьРеквизитыОбъектовМД(СписокОбъектов) Экспорт
	
	Реквизиты = Новый СписокЗначений();
	
	Для Каждого СтрокаСписка Из СписокОбъектов Цикл
		
		текРеквизиты = ПолучитьРеквизитыОбъектаМД(СтрокаСписка.Значение);
		Если ЗначениеЗаполнено(текРеквизиты) Тогда
			Реквизиты = ОтфильтроватьРеквизитыОбъектовМД(Реквизиты, текРеквизиты);
		КонецЕсли;
			
	КонецЦикла;
	
	Возврат Реквизиты;
	
КонецФункции

// Формирует текст запроса для отбора объекта
//
&НаСервереБезКонтекста
Функция СформироватьТекстЗапросаПоСписку(Знач СписокОбъектовМД, ДляИзменения, ПереданныйОбъект, ДляСКД = Ложь)
	
	Перем ТекстЗапроса;
	
	ДляИзмененияСтрока = ?(ДляИзменения, ".Изменения", "");
	
	ТекстЗапроса = 
		"ВЫБРАТЬ 
		|	ТаблицаСсылок.Ссылка КАК Ссылка";
	
	Если (ПереданныйОбъект <> "Регистр") Тогда
		СписокОбщихРеквизитов = ПолучитьРеквизитыОбъектовМД(СписокОбъектовМД);
		Для А = 0 По СписокОбщихРеквизитов.Количество() - 1 Цикл 
			ИмяРеквизита = СписокОбщихРеквизитов[А];
			ТекстЗапроса = ТекстЗапроса + ",
				|	ТаблицаСсылок.Ссылка." + ИмяРеквизита + " КАК " + ИмяРеквизита;
		КонецЦикла; //Для  По  
	КонецЕсли; 
	
	ТекстЗапроса = ТекстЗапроса + "
		|ИЗ
		|(
		|";
	
	НомерПП = 0;
	Для каждого ИмяТаблицыДанных Из СписокОбъектовМД Цикл
			
		ИмяТаблицыДанных = ИмяТаблицыДанных.Значение;
		НомерПП = НомерПП + 1;
		ИмяОбъекта = Сред(ИмяТаблицыДанных, Найти(ИмяТаблицыДанных, ".") + 1);
		ТекстЗапроса = ТекстЗапроса + "
			|ВЫБРАТЬ
			|	%ИмяОбъекта%.Ссылка КАК Ссылка
			|ИЗ
			|	%ИмяТаблицыДанных%%Изменения% КАК %ИмяОбъекта%
			|";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ИмяТаблицыДанных%", ИмяТаблицыДанных);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Изменения%", ДляИзмененияСтрока);
		Если ДляИзменения Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|ГДЕ
			|	%ИмяОбъекта%.Узел = &УзелОбмена
			|";
		КонецЕсли; 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ИмяОбъекта%", ИмяОбъекта);
		Если НомерПП < СписокОбъектовМД.Количество() Тогда
			ТекстЗапроса = ТекстЗапроса + "
				|ОБЪЕДИНИТЬ ВСЕ
				|";
		КонецЕсли; 
		
	КонецЦикла; //Для каждого  Из   	
		
	ТекстЗапроса = ТекстЗапроса + "
		|) КАК ТаблицаСсылок
		|";
	
	Если (ПереданныйОбъект = "Документ" ИЛИ ПереданныйОбъект = "Регистр") И ДляИзменения Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|ГДЕ
		|	ТаблицаСсылок.Ссылка.Дата МЕЖДУ &НачДата И &КонДата";
	ИначеЕсли (ПереданныйОбъект = "Документ" ИЛИ ПереданныйОбъект = "Регистр") И НЕ ДляИзменения Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|ГДЕ
		|	ТаблицаСсылок.Ссылка.Дата МЕЖДУ &НачДата И &КонДата";
	КонецЕсли; 
	
	Если (ПереданныйОбъект = "Документ" ИЛИ ПереданныйОбъект = "Регистр") Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|УПОРЯДОЧИТЬ ПО
		|	ТаблицаСсылок.Ссылка.Дата ВОЗР";
	КонецЕсли; 
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Процедура СформироватьСхемуКомпоновкиДанных()
	
	СхемаКомпоновки = Новый СхемаКомпоновкиДанных();		
    	
	Источник = СхемаКомпоновки.ИсточникиДанных.Добавить();
	Источник.Имя = "Источник";
	Источник.СтрокаСоединения="";
	Источник.ТипИсточникаДанных = "local";
	
	Если ПереданныйОбъект = "Документ" ИЛИ ПереданныйОбъект = "Регистр" Тогда
		Если ПереданныйОбъект = "Документ" Тогда
			СтрокаЗамены = "ИСТИНА 
					|{ГДЕ ТаблицаСсылок.Ссылка.Дата >= &НачДата}
					|{ГДЕ ТаблицаСсылок.Ссылка.Дата <= &КонДата}";
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ТаблицаСсылок.Ссылка.Дата МЕЖДУ &НачДата И &КонДата", СтрокаЗамены);
		Иначе
			СтрокаЗамены = "ИСТИНА 
					|{ГДЕ ТаблицаСсылок.Регистратор.Дата >= &НачДата}
					|{ГДЕ ТаблицаСсылок.Регистратор.Дата <= &КонДата}";
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ТаблицаСсылок.Регистратор.Дата МЕЖДУ &НачДата И &КонДата", СтрокаЗамены);
		КонецЕсли;
	КонецЕсли; 
	
	НаборДанных = СхемаКомпоновки.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Запрос = ТекстЗапроса;
	НаборДанных.Имя = "Запрос";
	НаборДанных.ИсточникДанных = Источник.Имя;
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	
	Если Удалить Тогда
		ПараметрСКД = СхемаКомпоновки.Параметры.Добавить();
		ПараметрСКД.Имя = "УзелОбмена";
		ПараметрСКД.Использование = ИспользованиеПараметраКомпоновкиДанных.Авто;
		ПараметрСКД.ОграничениеИспользования = Истина;
		ПараметрСКД.ВключатьВДоступныеПоля = Ложь;
	КонецЕсли; 
	
	Если ПереданныйОбъект = "Документ" ИЛИ ПереданныйОбъект = "Регистр" Тогда
		ПараметрСКД = СхемаКомпоновки.Параметры.Добавить();
		ПараметрСКД.Имя = "Период";
		ПараметрСКД.ТипЗначения = Новый ОписаниеТипов("СтандартныйПериод");
		ПараметрСКД.Использование = ИспользованиеПараметраКомпоновкиДанных.Авто;
		ПараметрСКД.ОграничениеИспользования = Ложь;
		ПараметрСКД.ВключатьВДоступныеПоля = Ложь;
		
		ПараметрСКД = СхемаКомпоновки.Параметры.Добавить();
		ПараметрСКД.Имя = "НачДата";
		ПараметрСКД.Использование = ИспользованиеПараметраКомпоновкиДанных.Авто;
		ПараметрСКД.ОграничениеИспользования = Истина;
		ПараметрСКД.ВключатьВДоступныеПоля = Ложь;
		ПараметрСКД.Выражение = "&Период.ДатаНачала";
			
		ПараметрСКД = СхемаКомпоновки.Параметры.Добавить();
		ПараметрСКД.Имя = "КонДата";
		ПараметрСКД.Использование = ИспользованиеПараметраКомпоновкиДанных.Авто;
		ПараметрСКД.ОграничениеИспользования = Истина;
		ПараметрСКД.ВключатьВДоступныеПоля = Ложь;
		ПараметрСКД.Выражение = "&Период.ДатаОкончания";
	КонецЕсли; 
	
	НастройкиСКД = СхемаКомпоновки.НастройкиПоУмолчанию;
	ГруппировкаСКД = НастройкиСКД.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаСКД.Использование = Истина;
	ВыбранныеПоля = ГруппировкаСКД.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	ВыбранныеПоля.Использование = Истина;
	
	ВыбранныеПоля = ГруппировкаСКД.Выбор.Элементы;

	ВыбранноеПоле = ВыбранныеПоля.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Использование = Истина;
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	
	Если Удалить Тогда
		ПараметрДанных = НастройкиСКД.ПараметрыДанных.Элементы.Добавить();
		ПараметрДанных.Параметр = Новый ПараметрКомпоновкиДанных("УзелОбмена");
		ПараметрДанных.Использование = Истина;
		ПараметрДанных.Значение = УзелОбмена;
	КонецЕсли; 
	
	Если ПереданныйОбъект = "Документ" ИЛИ ПереданныйОбъект = "Регистр" Тогда
		
		ПараметрДанныхДатаНачала = ?(ЗначениеЗаполнено(ДатаНачала), ДатаНачала, Дата(1980, 1, 1));
		ПараметрДанныхДатаОкончания = ?(ЗначениеЗаполнено(ДатаОкончания), ДатаОкончания, КонецДня(ТекущаяДата()));
		
		ПараметрДанных = НастройкиСКД.ПараметрыДанных.Элементы.Добавить();
		ПараметрДанных.Параметр = Новый ПараметрКомпоновкиДанных("НачДата");
		ПараметрДанных.Использование = Истина;
		ПараметрДанных.Значение = ПараметрДанныхДатаНачала;
		
		ПараметрДанных = НастройкиСКД.ПараметрыДанных.Элементы.Добавить();
		ПараметрДанных.Параметр = Новый ПараметрКомпоновкиДанных("КонДата");
		ПараметрДанных.Использование = Истина;
		ПараметрДанных.Значение = ПараметрДанныхДатаОкончания;
		
		ПараметрДанных = НастройкиСКД.ПараметрыДанных.Элементы.Добавить();
		ПараметрДанных.Параметр = Новый ПараметрКомпоновкиДанных("Период");
		ПараметрДанных.Использование = Истина;
		ПараметрДанных.Значение = Новый СтандартныйПериод(ПараметрДанныхДатаНачала, ПараметрДанныхДатаОкончания);
	КонецЕсли; 
	
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновки, УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы);	
	ОтборДанных.Инициализировать(ИсточникНастроек); 
	ОтборДанных.ЗагрузитьНастройки(СхемаКомпоновки.НастройкиПоУмолчанию);
	
	Для каждого ЭлементДоступногоОтбора Из ОтборДанных.Настройки.ДоступныеПоляОтбора.Элементы Цикл    
		ДобавитьОтбор(ОтборДанных.Настройки.Отбор, ЭлементДоступногоОтбора.Поле, , ВидСравненияКомпоновкиДанных.Равно, Ложь);
	КонецЦикла; //Для каждого ЭлементДоступногоОтбора Из   
	
	НовыйПорядок = ОтборДанных.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
    НовыйПорядок.Использование = Истина;
    НовыйПорядок.Поле = Новый ПолеКомпоновкиДанных("Ссылка");
    НовыйПорядок.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	Если РежимОтбора = 1 Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ПроизвольныйЗапрос;
		Элементы.ПроизвольныйЗапрос.Доступность = Истина;
		Элементы.ОтборПоЗначениямРеквизитов.Доступность = Ложь;
	Иначе
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ОтборПоЗначениямРеквизитов;
		Элементы.ПроизвольныйЗапрос.Доступность = Ложь;
		Элементы.ОтборПоЗначениямРеквизитов.Доступность = Истина;
	КонецЕсли;
	ГруппаСтраницыПриСменеСтраницы(Неопределено, Элементы.ГруппаСтраницы.ТекущаяСтраница);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСсылокИзменитьВыбор(Выбор)
	Для Каждого Стр Из ТаблицаСсылок Цикл
		Стр.Выбрать = Выбор;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоПлатформа82 = Параметры.ЭтоПлатформа82;
	РежимСовместимости82 = Параметры.РежимСовместимости82;
	ИспользованиеМодальности = Параметры.ИспользованиеМодальности;
	
	Если Параметры.Свойство("ДатаНачала") Тогда
		ДатаНачала = Параметры.ДатаНачала;
	КонецЕсли; 
	Если Параметры.Свойство("ДатаОкончания") Тогда
		ДатаОкончания = Параметры.ДатаОкончания;
	КонецЕсли; 
	Если Параметры.Свойство("Удалить") Тогда
		Удалить = Параметры.Удалить;
	КонецЕсли; 
	Если Параметры.Свойство("УзелОбмена") Тогда
		УзелОбмена = Параметры.УзелОбмена;
	КонецЕсли; 
	Если Параметры.Свойство("РежимОтбора") Тогда
		РежимОтбора = Параметры.РежимОтбора;
	КонецЕсли; 
	
	Если Параметры.Свойство("СписокОбъектовМД") И ТипЗнч(Параметры.СписокОбъектовМД) = Тип("Массив") Тогда
		СписокОбъектовМД.ЗагрузитьЗначения(Параметры.СписокОбъектовМД);
	КонецЕсли; 
	
	ИмяМетаданных = Параметры.ИмяМетаданных;
	Если Удалить Тогда
		ЭтаФорма.Заголовок = "Произвольное удаление регистрации [" + ИмяМетаданных + "]";
		Элементы.ТаблицаСсылокВыполнить.Заголовок = НСтр("ru = 'Удалить регистрацию изменений'");
	Иначе
		ЭтаФорма.Заголовок = "Произвольная регистрация [" + ИмяМетаданных + "]";
		Элементы.ТаблицаСсылокВыполнить.Заголовок = НСтр("ru = 'Зарегистрировать изменения'");
	КонецЕсли; 

	Элементы.РежимОтбора.СписокВыбора.Добавить(0, "По реквизитам");
	Элементы.РежимОтбора.СписокВыбора.Добавить(1, "Произвольный запрос");
	
	Элементы.РежимВыполнения.СписокВыбора.Добавить("Сервер", "на сервере");
	Элементы.РежимВыполнения.СписокВыбора.Добавить("Клиент", "на клиенте");
	Если НЕ ЗначениеЗаполнено(РежимВыполнения) Тогда
		РежимВыполнения = "Сервер";
	КонецЕсли; 
	
	ПолноеИмяМетаданных = Параметры.ПолноеИмяМетаданных;
	
	ПереданныйОбъект = "";
	Если Параметры.Уровень = 2 И ЗначениеЗаполнено(ПолноеИмяМетаданных) И НЕ ЭтоНезависимыйРегистр(ПолноеИмяМетаданных) Тогда
		ПереданныйОбъект = ?(ЭтоДокумент(ПолноеИмяМетаданных), "Документ", ?(ЭтоРегистр(ПолноеИмяМетаданных), "Регистр", ""));
		ТекстЗапроса = СформироватьТекстЗапроса(ПолноеИмяМетаданных, Удалить, ПереданныйОбъект, Истина);
	ИначеЕсли СписокОбъектовМД.Количество() > 0 Тогда
		ПереданныйОбъект = ?(ИмяМетаданных = "Документы", "Документ", "");
		ТекстЗапроса = СформироватьТекстЗапросаПоСписку(СписокОбъектовМД, Удалить, ПереданныйОбъект, Истина);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
		ТекстПроизвольногоЗапроса = ТекстЗапроса;
		СформироватьСхемуКомпоновкиДанных();
		Если ПереданныйОбъект = "Документ" ИЛИ ПереданныйОбъект = "Регистр" Тогда
			НовСтр = ПараметрыЗапроса.Добавить();
			НовСтр.ИмяПараметра = "НачДата";
			НовСтр.ЗначениеПараметра = ?(ЗначениеЗаполнено(ДатаНачала), ДатаНачала, НачалоДня(ТекущаяДата()));
			
			НовСтр = ПараметрыЗапроса.Добавить();
			НовСтр.ИмяПараметра = "КонДата";
			НовСтр.ЗначениеПараметра =  ?(ЗначениеЗаполнено(ДатаОкончания), ДатаОкончания, КонецДня(ТекущаяДата()));
		КонецЕсли;
	КонецЕсли; 
	
	Если НЕ (ПереданныйОбъект = "Документ" ИЛИ ПереданныйОбъект = "Регистр") Тогда
		Элементы.ОтборДанныхНастройкиПараметрыДанных.Видимость = Ложь;
	КонецЕсли; 
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НЕ ЭтоПлатформа82 И НЕ РежимСовместимости82 Тогда
		Элементы.КонтекстноеМенюТекстЗапросаКонструкторЗапроса.Доступность = Истина;
		Элементы.КонструкторЗапроса.Доступность = Истина;
	Иначе
		#Если ТолстыйКлиентУправляемоеПриложение  Тогда
			Элементы.КонтекстноеМенюТекстЗапросаКонструкторЗапроса.Доступность = Истина;
			Элементы.КонструкторЗапроса.Доступность = Истина;
		#КонецЕсли
	КонецЕсли; 
    УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура РежимОтбораПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗапросаЗначениеПараметраОчистка(Элемент, СтандартнаяОбработка)
	Элемент.ВыбиратьТип = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.ОтборПоЗначениямРеквизитов Тогда
		Элементы.ОтборДанныхЗаполнить.КнопкаПоУмолчанию = Истина;
	ИначеЕсли ТекущаяСтраница = Элементы.ПроизвольныйЗапрос Тогда
		Элементы.ПроизвольныйЗапросЗаполнить.КнопкаПоУмолчанию = Истина;
	ИначеЕсли ТекущаяСтраница = Элементы.ГруппаДанные Тогда
		Элементы.ТаблицаСсылокВыполнить.КнопкаПоУмолчанию = Истина;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСсылокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначениеУниверсальное(Элемент.ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	Результат = ВыполнитьЗапрос();
	Если Результат = Истина Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДанные;
		ГруппаСтраницыПриСменеСтраницы(Неопределено, Элементы.ГруппаСтраницы.ТекущаяСтраница);
	Иначе
		ПоказатьПредупреждениеУниверсальное(НСтр("ru = 'Ошибка '") + Результат);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	СтруктураВозврата = Новый Структура;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Выбрать", Истина);
	МассивСтрок = ТаблицаСсылок.НайтиСтроки(СтруктураОтбора);
	
	СтруктураВозврата.Вставить("Строки", МассивСтрок);
	СтруктураВозврата.Вставить("ПереданныйОбъект", ПереданныйОбъект);
	СтруктураВозврата.Вставить("РежимВыполнения", РежимВыполнения);
	
	Закрыть(СтруктураВозврата);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	ТаблицаСсылокИзменитьВыбор(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыбор(Команда)
	ТаблицаСсылокИзменитьВыбор(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КонструкторЗапроса(Команда)
	КонструкторЗапроса = Неопределено;
	Если ЭтоПлатформа82 ИЛИ РежимСовместимости82 Тогда
		#Если ТолстыйКлиентУправляемоеПриложение  Тогда
		Выполнить("КонструкторЗапроса = Новый КонструкторЗапроса;");
		Если НЕ ПустаяСтрока(ТекстПроизвольногоЗапроса) Тогда 
			КонструкторЗапроса.Текст = ТекстПроизвольногоЗапроса;
		КонецЕсли;
		Если КонструкторЗапроса.ОткрытьМодально() Тогда 
			ТекстПроизвольногоЗапроса = КонструкторЗапроса.Текст;
		КонецЕсли;
		#КонецЕсли
	Иначе
		Выполнить("КонструкторЗапроса = Новый КонструкторЗапроса;");
		Если НЕ ПустаяСтрока(ТекстПроизвольногоЗапроса) Тогда 
			КонструкторЗапроса.Текст = ТекстПроизвольногоЗапроса;
		КонецЕсли;
		Выполнить("Оповещение = Новый ОписаниеОповещения(""ВыполнитьПослеЗакрытияКонструктораЗапроса"", ЭтаФорма);
				|КонструкторЗапроса.Показать(Оповещение);");
		
	КонецЕсли; 
КонецПроцедуры

Процедура ВыполнитьПослеЗакрытияКонструктораЗапроса(Текст, ДополнительныеПараметры)
	Если Текст <> Неопределено Тогда
		ТекстПроизвольногоЗапроса = Текст;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметры(Команда)
	Результат = ЗаполнитьПараметрыЗапроса();
	Если Результат <> Истина Тогда
		ПоказатьПредупреждениеУниверсальное(НСтр("ru = 'Ошибка '") + Результат);
	КонецЕсли;
КонецПроцедуры