﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СвернутьРазвернутьПанель(СвернутьПанель);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;	
	
	УсловияОтбора = Новый Структура("Контрагент", ТекущиеДанные.Ссылка);
	ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии", УсловияОтбора, Истина);
		
	Если НавигационнаяСсылкаФорматированнойСтроки = "РасчетыСПоставщиками" Тогда
		ОткрытьФорму("Отчет.РасчетыСПоставщиками.Форма", ПараметрыФормы,ЭтотОбъект, ТекущиеДанные.Ссылка); 
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "РасчетыСКлиентами" Тогда
		ОткрытьФорму("Отчет.РасчетыСКлиентами.Форма", 	 ПараметрыФормы,ЭтотОбъект, ТекущиеДанные.Ссылка);  
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьТекущиеДанные(Список)
	
	Если Список.ТекущиеДанные = Неопределено Тогда // Нет текущей строки.
		Возврат Неопределено;
	ИначеЕсли Список.ТекущиеДанные.Свойство("ГруппировкаСтроки") 
		И Список.ТекущиеДанные.ГруппировкаСтроки <> Неопределено Тогда // Это строка группировки.
		Возврат Неопределено;
	Иначе
		Возврат Список.ТекущиеДанные;
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура ПриАктивизацииСтроки()
	
	Если СвернутьПанель Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ПолучитьТекущиеДанные(Элементы.Список);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РазместитьДанныеКонтрагента(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура РазместитьДанныеКонтрагента(Знач Контрагент)
	
	ДанныеКонтрагента = ДанныеДляЗаполненияПоКонтрагенту(Контрагент);
	
	Элементы.ДекорацияНаименованиеПолное.Заголовок = ДанныеКонтрагента.НаименованиеПолное;
	Элементы.ДекорацияДолгНам.Заголовок = НадписьВзаиморасчетов(ДанныеКонтрагента.ДолгНам, "Дт");
	Элементы.ДекорацияДолгНаш.Заголовок = НадписьВзаиморасчетов(ДанныеКонтрагента.ДолгНаш, "Кт");
	
	Если ПустаяСтрока(ДанныеКонтрагента.ИНН) Тогда
		Элементы.ДекорацияИНН.Видимость = Ложь;
	Иначе
		Элементы.ДекорацияИНН.Видимость = Истина;
		Элементы.ДекорацияИНН.Заголовок = СтрШаблон(НСтр("ru='ИНН: %1'"), СокрЛП(ДанныеКонтрагента.ИНН));
	КонецЕсли;
	
	Если ПустаяСтрока(ДанныеКонтрагента.КПП) Тогда
		Элементы.ДекорацияКПП.Видимость = Ложь;
	Иначе
		Элементы.ДекорацияКПП.Видимость = Истина;
		Элементы.ДекорацияКПП.Заголовок = СтрШаблон(НСтр("ru='КПП: %1'"), СокрЛП(ДанныеКонтрагента.КПП));
	КонецЕсли;
	
	Если ПустаяСтрока(ДанныеКонтрагента.Адрес) Тогда
		Элементы.ДекорацияАдрес.Видимость = Ложь;
	Иначе
		Элементы.ДекорацияАдрес.Видимость = Истина;
		Элементы.ДекорацияАдрес.Заголовок = СтрШаблон(НСтр("ru='Юр. адрес: %1'"), СокрЛП(ДанныеКонтрагента.Адрес));
	КонецЕсли;
	
	Если ПустаяСтрока(ДанныеКонтрагента.Телефон) Тогда
		Элементы.ДекорацияТелефон.Видимость = Ложь;
	Иначе
		Элементы.ДекорацияТелефон.Видимость = Истина;
		Элементы.ДекорацияТелефон.Заголовок = СтрШаблон(НСтр("ru='Телефон: %1'"), ДанныеКонтрагента.Телефон);
	КонецЕсли;

	Если ПустаяСтрока(ДанныеКонтрагента.ЭлПочта) Тогда
		Элементы.ДекорацияЕмаил.Видимость = Ложь;
	Иначе
		Элементы.ДекорацияЕмаил.Видимость = Истина;
		Элементы.ДекорацияЕмаил.Заголовок = СтрШаблон(НСтр("ru='E-mail: %1'"), ДанныеКонтрагента.ЭлПочта);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СвернутьРазвернутьПанель(СвернутьПанель)
	
	Если СвернутьПанель Тогда
		Элементы.ПанельИнформации.Видимость = Ложь;
		Элементы.ГруппаЗаглушка.Видимость   = Истина;
	Иначе
		Элементы.ПанельИнформации.Видимость = Истина;
		Элементы.ГруппаЗаглушка.Видимость   = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеДляЗаполненияПоКонтрагенту(Знач Контрагент)
	
	ДанныеКонтрагента = Новый Структура;
	ДанныеКонтрагента.Вставить("НаименованиеПолное", "Полное наименование");
	ДанныеКонтрагента.Вставить("ИНН",                "");
	ДанныеКонтрагента.Вставить("КПП",                "");
	ДанныеКонтрагента.Вставить("ДолгНам",          0);
	ДанныеКонтрагента.Вставить("ДолгНаш",         0);
	ДанныеКонтрагента.Вставить("Адрес",              "");
	ДанныеКонтрагента.Вставить("Телефон",            "");
	ДанныеКонтрагента.Вставить("ЭлПочта",              "");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КонтрагентЮрАдрес.Представление КАК ЮрАдрес,
		|	КонтрагентЮрАдрес.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ втЮрАдр
		|ИЗ
		|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентЮрАдрес
		|ГДЕ
		|	КонтрагентЮрАдрес.Вид = &ВидЮрАдрес
		|	И КонтрагентЮрАдрес.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КонтрагентыТелефон.Представление КАК Телефон,
		|	КонтрагентыТелефон.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ втТелефон
		|ИЗ
		|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыТелефон
		|ГДЕ
		|	КонтрагентыТелефон.Вид = &ВидТелефон
		|	И КонтрагентыТелефон.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КонтрагентыЭлПочта.Представление КАК ЭлПочта,
		|	КонтрагентыЭлПочта.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ втЭлПочта
		|ИЗ
		|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыЭлПочта
		|ГДЕ
		|	КонтрагентыЭлПочта.Вид = &ВидЭлПочта
		|	И КонтрагентыЭлПочта.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Контрагенты.Ссылка КАК Ссылка,
		|	втЮрАдр.ЮрАдрес КАК ЮрАдрес,
		|	втЭлПочта.ЭлПочта КАК ЭлПочта,
		|	втТелефон.Телефон КАК Телефон
		|ПОМЕСТИТЬ втКонтИнф
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ЛЕВОЕ СОЕДИНЕНИЕ втЮрАдр КАК втЮрАдр
		|		ПО Контрагенты.Ссылка = втЮрАдр.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ втТелефон КАК втТелефон
		|		ПО Контрагенты.Ссылка = втТелефон.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ втЭлПочта КАК втЭлПочта
		|		ПО Контрагенты.Ссылка = втЭлПочта.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РасчетыСКлиентами.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	РегистрАналитикаУчетаПоПартнерам.Организация КАК Организация,
		|	РегистрАналитикаУчетаПоПартнерам.Партнер КАК Партнер,
		|	РегистрАналитикаУчетаПоПартнерам.Контрагент КАК Контрагент,
		|	РегистрАналитикаУчетаПоПартнерам.Договор КАК Договор,
		|	РасчетыСКлиентами.Валюта КАК ВалютаВзаиморасчетов,
		|	РасчетыСКлиентами.ДолгКонечныйОстаток КАК ДолгКонечныйОстаток,
		|	РасчетыСКлиентами.ДолгРеглКонечныйОстаток КАК ДолгРеглКонечныйОстаток,
		|	""Клиент"" КАК ВзаиморасчетыС
		|ПОМЕСТИТЬ втВзаиморасчеты
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентамиПоДокументам.ОстаткиИОбороты(, , Авто, , ) КАК РасчетыСКлиентами
		|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК РегистрАналитикаУчетаПоПартнерам
		|		ПО РасчетыСКлиентами.АналитикаУчетаПоПартнерам = РегистрАналитикаУчетаПоПартнерам.КлючАналитики}
		|ГДЕ
		|	РегистрАналитикаУчетаПоПартнерам.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
		|	И РегистрАналитикаУчетаПоПартнерам.Контрагент = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РасчетыСПоставщиками.АналитикаУчетаПоПартнерам,
		|	РегистрАналитикаУчетаПоПартнерам.Организация,
		|	РегистрАналитикаУчетаПоПартнерам.Партнер,
		|	РегистрАналитикаУчетаПоПартнерам.Контрагент,
		|	РегистрАналитикаУчетаПоПартнерам.Договор,
		|	РасчетыСПоставщиками.Валюта,
		|	РасчетыСПоставщиками.ДолгКонечныйОстаток,
		|	РасчетыСПоставщиками.ДолгРеглКонечныйОстаток,
		|	""Поставщик""
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщикамиПоДокументам.ОстаткиИОбороты(, , Авто, , ) КАК РасчетыСПоставщиками
		|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК РегистрАналитикаУчетаПоПартнерам
		|		ПО РасчетыСПоставщиками.АналитикаУчетаПоПартнерам = РегистрАналитикаУчетаПоПартнерам.КлючАналитики}
		|ГДЕ
		|	РегистрАналитикаУчетаПоПартнерам.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
		|	И РегистрАналитикаУчетаПоПартнерам.Контрагент = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ втЮрАдр
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ втТелефон
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ втЭлПочта
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втВзаиморасчеты.Контрагент КАК Ссылка,
		|	СУММА(ВЫБОР
		|			КОГДА втВзаиморасчеты.ВзаиморасчетыС = ""Клиент""
		|				ТОГДА втВзаиморасчеты.ДолгКонечныйОстаток
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ДолгНамРегл,
		|	СУММА(ВЫБОР
		|			КОГДА втВзаиморасчеты.ВзаиморасчетыС = ""Поставщик""
		|				ТОГДА -втВзаиморасчеты.ДолгКонечныйОстаток
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ДолгНашРегл
		|ПОМЕСТИТЬ втОстРегл
		|ИЗ
		|	втВзаиморасчеты КАК втВзаиморасчеты
		|
		|СГРУППИРОВАТЬ ПО
		|	втВзаиморасчеты.Контрагент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ втВзаиморасчеты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Контрагенты.ИНН КАК ИНН,
		|	Контрагенты.КПП КАК КПП,
		|	Контрагенты.НаименованиеПолное КАК НаименованиеПолное,
		|	ВЫБОР
		|		КОГДА втОстРегл.ДолгНамРегл ЕСТЬ NULL 
		|			ТОГДА ""0""
		|		ИНАЧЕ втОстРегл.ДолгНамРегл
		|	КОНЕЦ КАК ДолгНам,
		|	ВЫБОР
		|		КОГДА втОстРегл.ДолгНашРегл ЕСТЬ NULL 
		|			ТОГДА ""0""
		|		ИНАЧЕ втОстРегл.ДолгНашРегл
		|	КОНЕЦ КАК ДолгНаш,
		|	втКонтИнф.ЮрАдрес КАК ЮрАдрес,
		|	втКонтИнф.ЭлПочта КАК ЭлПочта,
		|	втКонтИнф.Телефон КАК Телефон
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ЛЕВОЕ СОЕДИНЕНИЕ втКонтИнф КАК втКонтИнф
		|		ПО Контрагенты.Ссылка = втКонтИнф.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ втОстРегл КАК втОстРегл
		|		ПО Контрагенты.Ссылка = втОстРегл.Ссылка
		|ГДЕ
		|	Контрагенты.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("ВидТелефон", Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента);
	Запрос.УстановитьПараметр("ВидЭлПочта", Справочники.ВидыКонтактнойИнформации.EmailКонтрагента);
	Запрос.УстановитьПараметр("ВидЮрАдрес", Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента);
	Запрос.УстановитьПараметр("Ссылка", Контрагент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ДанныеКонтрагента, Выборка);
	КонецЕсли;
	
	Возврат ДанныеКонтрагента;
	
КонецФункции

&НаСервереБезКонтекста
Функция НадписьВзаиморасчетов(Знач Сумма, Знач ДтКт)
	
	КрупныйШрифт = Новый Шрифт(,11);
	МелкийШрифт = Новый Шрифт(,8);
	
	КомпонентыФС = Новый Массив;
	Если ДтКт = "Кт" Тогда
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='Мы должны'") + " ", КрупныйШрифт));
		СсылкаНаОтчет = "РасчетыСПоставщиками";
	Иначе
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='Должен нам'") + " ", КрупныйШрифт));
		СсылкаНаОтчет = "РасчетыСКлиентами";
	КонецЕсли;
	
	СуммаСтрокой = Формат(Сумма, "ЧДЦ=2; ЧРД=,; ЧРГ=' '; ЧН=0,00");
	ПозицияРазделителя = СтрНайти(СуммаСтрокой, ",");
	КомпонентыЧисла = Новый Массив;
	КомпонентыЧисла.Добавить(Новый ФорматированнаяСтрока(Лев(СуммаСтрокой, ПозицияРазделителя), КрупныйШрифт));
	КомпонентыЧисла.Добавить(Новый ФорматированнаяСтрока(Сред(СуммаСтрокой, ПозицияРазделителя+1), МелкийШрифт));
	КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(КомпонентыЧисла, , , , СсылкаНаОтчет));
	КомпонентыФС.Добавить(" " + Константы.ВалютаРегламентированногоУчета.Получить());
	
	Возврат Новый ФорматированнаяСтрока(КомпонентыФС, , ЦветаСтиля.ПоясняющийТекст);
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДекорацияДокументыНажатие(Элемент)

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Настройки = Новый НастройкиКомпоновкиДанных;
	
	Отбор = Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Контрагент");
	Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	Отбор.ПравоеЗначение = ТекущиеДанные.Ссылка;
	Отбор.Использование = Истина;	
	Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ФиксированныеНастройки", Настройки);
	                      
	ОткрытьФорму("ЖурналДокументов.РеестрТорговыхДокументов.Форма.ФормаСписка",ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ПриАктивизацииСтроки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазвернутьНажатие(Элемент)
	
	СвернутьПанель = НЕ СвернутьПанель;
	СвернутьРазвернутьПанель(СвернутьПанель);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСвернутьНажатие(Элемент)
	
	СвернутьПанель = НЕ СвернутьПанель;
	СвернутьРазвернутьПанель(СвернутьПанель);
	
КонецПроцедуры

#КонецОбласти