﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура КУТ_ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	УсловияОтбора = Новый Структура("Партнер", ТекущиеДанные.Ссылка);
	ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии", УсловияОтбора, Истина);
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "РасчетыСПоставщиками" Тогда
		ОткрытьФорму("Отчет.РасчетыСПоставщиками.Форма", ПараметрыФормы, ЭтотОбъект, ТекущиеДанные.Ссылка); 
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "РасчетыСКлиентами" Тогда
		ОткрытьФорму("Отчет.РасчетыСКлиентами.Форма", ПараметрыФормы, ЭтотОбъект, ТекущиеДанные.Ссылка);  
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
Процедура КУТ_ПриАктивизацииСтроки()
	
	ТекущиеДанные = ПолучитьТекущиеДанные(Элементы.Список);
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	КУТ_РазместитьДанныеПартнера(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура КУТ_РазместитьДанныеПартнера(Знач Партнер)
	
	Если Партнер.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	ДанныеПартнера = Обработки.ЗадолженностьПартнеров.ЗадолженностьПартнера(Партнер);
	
	Элементы.ДекорацияДолгНам.Заголовок = КУТ_НадписьВзаиморасчетов(ДанныеПартнера.НамДолжны, "Дт");
	Элементы.ДекорацияДолгНаш.Заголовок = КУТ_НадписьВзаиморасчетов(ДанныеПартнера.МыДолжны, "Кт");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КУТ_НадписьВзаиморасчетов(Знач Сумма, Знач ДтКт)
	
	КрупныйШрифт = Новый Шрифт(,11);
	МелкийШрифт = Новый Шрифт(,8);
	
	КомпонентыФС = Новый Массив;
	Если ДтКт = "Кт" Тогда
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='Мы должны'") + " ", КрупныйШрифт, ЦветаСтиля.ПоясняющийТекст));
		СсылкаНаОтчет = "РасчетыСПоставщиками";
	Иначе
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='Должен нам'") + " ", КрупныйШрифт, ЦветаСтиля.ПоясняющийТекст));
		СсылкаНаОтчет = "РасчетыСКлиентами";
	КонецЕсли;
	
	СуммаСтрокой = Формат(Сумма, "ЧДЦ=2; ЧРД=,; ЧРГ=' '; ЧН=0,00");
	ПозицияРазделителя = СтрНайти(СуммаСтрокой, ",");
	КомпонентыЧисла = Новый Массив;
	КомпонентыЧисла.Добавить(Новый ФорматированнаяСтрока(Лев(СуммаСтрокой, ПозицияРазделителя), КрупныйШрифт));
	КомпонентыЧисла.Добавить(Новый ФорматированнаяСтрока(Сред(СуммаСтрокой, ПозицияРазделителя+1), МелкийШрифт));
	КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(КомпонентыЧисла, , , , СсылкаНаОтчет));
	
	Возврат Новый ФорматированнаяСтрока(КомпонентыФС);
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КУТ_ДекорацияДокументыНажатие(Элемент)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Настройки = Новый НастройкиКомпоновкиДанных;
	
	Отбор = Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Партнер");
	Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	Отбор.ПравоеЗначение = ТекущиеДанные.Ссылка;
	Отбор.Использование = Истина;	
	Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ФиксированныеНастройки", Настройки);
		
	ОткрытьФорму("ЖурналДокументов.РеестрТорговыхДокументов.Форма.ФормаСписка",ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КУТ_СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("КУТ_ПриАктивизацииСтроки", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти