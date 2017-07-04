﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПодборТоваров_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Документ <> Неопределено Тогда
		ТипДокумента = ТипЗнч(Параметры.Документ);
		Если ТипДокумента = Тип("ДокументСсылка.ЗаказПоставщику")
			Или ТипДокумента =  Тип("ДокументСсылка.ЗаказКлиента")
			Или ТипДокумента =  Тип("ДокументСсылка.ПоступлениеТоваровУслуг")
			Или ТипДокумента =  Тип("ДокументСсылка.РеализацияТоваровУслуг")
			Или ТипДокумента =  Тип("ДокументСсылка.ПеремещениеТоваров")
			Или ТипДокумента =  Тип("ДокументСсылка.ЗаказНаПеремещение")
			Или ТипДокумента =  Тип("ДокументСсылка.ЧекККМ") Тогда
			ЭтоРасширеннаяФорма = Истина;
		КонецЕсли;
	КонецЕсли;
	Элементы.ГруппаСкладов.Видимость = ЭтоРасширеннаяФорма И Склады.Количество() <> 0;;
	Если ЭтоРасширеннаяФорма Тогда
		СкладДляСоединения = Параметры.Склад;
		ИзменитьТекстЗапроса();
		ЕстьПравоДоступаКОтчету = ПравоДоступа("Использование", Метаданные.Отчеты.ПоступлениеИОтгрузкаТоваров);
		ПодборТоваров_УстановитьУсловноеОформлениеДинамическихСписков(ЭтаФорма, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодборТоваров_ОтображатьОстаткиНадписьНажатиеВместо(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПриИзмененииОтображенияОстатковПоСкладамДокумента(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборТоваров_ИспользоватьФильтрыПриИзменении(Элемент)
	ПодборТоваров_ИспользоватьФильтрыПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПодборТоваров_ИспользоватьФильтрыПриИзмененииНаСервере()
	
	ПодборТоваровСервер.ПриИзмененииИспользованияФильтров(ЭтаФорма);
	ИзменитьТекстЗапроса();
		
КонецПроцедуры

&НаКлиенте
Процедура ПодборТоваров_ГруппаСкладовПриИзмененииВместо(Элемент)
	
	Если ЭтоРасширеннаяФорма Тогда
		ПодключитьОбработчикОжидания("ПодборТоваров_ПодборТаблицаПриАктивизацииСтрокиОбработчикОжидания",0.1,Истина);
	Иначе
		ПодключитьОбработчикОжидания("ПодборТаблицаПриАктивизацииСтрокиОбработчикОжидания",0.1,Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборТоваров_ИзменитьВариантНавигацииВместо(Команда)
	
	СписокВыбораВариантовНавигации = Новый СписокЗначений;
	СписокВыбораВариантовНавигации.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИСвойствам"),
											НСтр("ru = 'Навигация по видам и свойствам'"));
	СписокВыбораВариантовНавигации.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоИерархии"),
											НСтр("ru = 'Навигация по иерархии'"));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодборТоваров_ИзменитьВариантНавигацииЗавершение", ЭтотОбъект);
	
	ЭтаФорма.ПоказатьВыборИзМеню(ОписаниеОповещения,
								СписокВыбораВариантовНавигации,
								Элементы.КоманднаяПанельВариантНавигации);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыСписокРасширенныйПоискНоменклатура

&НаКлиенте
Процедура ПодборТоваров_СписокРасширенныйПоискНоменклатураПриАктивизацииСтрокиВместо(Элемент)
	
	ИмяСпискаНоменклатуры = ПодборТоваровКлиентСервер.ИмяСпискаНоменклатурыПоВариантуПоиска(ЭтаФорма);
	
	Если Элемент.Имя <> ИмяСпискаНоменклатуры Тогда
		Возврат;
	КонецЕсли;
	
	Если НавигацияПоХарактеристикам Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицыНоменклатуры = Элемент.ТекущиеДанные;
	
	Если СтрокаТаблицыНоменклатуры = Неопределено Тогда
		
		ПодборТоваровКлиентСервер.ОчиститьТаблицуОстатков(ЭтаФорма);
		ТекущаяСтрокаНоменклатуры = ПодборТоваровКлиентСервер.СтруктураСтрокиНоменклатуры();
		
	Иначе
		
		Если ТекущаяСтрокаНоменклатуры <> Неопределено Тогда
			
			Если (ТекущаяСтрокаНоменклатуры.Номенклатура = СтрокаТаблицыНоменклатуры.Номенклатура) Тогда
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
		ТекущаяСтрокаНоменклатуры = ПодборТоваровКлиентСервер.СтруктураСтрокиНоменклатуры();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрокаНоменклатуры, СтрокаТаблицыНоменклатуры);
		
		ПодборТоваровКлиент.УстановитьТекущуюСтрокуИерархииНоменклатуры(ЭтаФорма);
		
		Если ОтображатьОстатки Тогда
			Если ЭтоРасширеннаяФорма Тогда
				ПодключитьОбработчикОжидания("ПодборТоваров_ПодборТаблицаПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
			Иначе
				ПодключитьОбработчикОжидания("ПодборТаблицаПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборТоваров_СписокРасширенныйПоискНоменклатураВыборВместо(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// Если выбрана колонка "Ожидается", тогда открываем отчет, иначе стандартное поведение.
	Если Поле.Имя = "СписокРасширенныйПоискНоменклатураОжидается" Тогда
		ОткрытьОтчетПоступлениеИОтгрузкаТоваров();
	Иначе
		// Проверить выбранную строку номенклатуры.
		Оповещение = Новый ОписаниеОповещения("ПодборТаблицаНоменклатураВыборЗавершение", ЭтотОбъект, 
			Новый Структура("Элемент", Элемент));
		ПодборТоваровКлиент.ПриВыбореСтрокиТаблицыНоменклатуры(ЭтаФорма, Оповещение);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыНоменклатуры

&НаКлиенте
Процедура ПодборТоваров_ВидыНоменклатурыПриАктивизацииСтрокиВместо(Элемент)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"ОбщийМодуль.ПодборТоваровКлиент.ПриАктивизацииСтрокиСпискаВидыНоменклатуры");
	
	Если Не (ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоСвойствам")
		Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИСвойствам")
		Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидам")) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ВидыНоменклатуры.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено
		Или ВидНоменклатуры = ТекущиеДанные.Ссылка Тогда
		Возврат;
	КонецЕсли;
	
	ВидНоменклатуры = ТекущиеДанные.Ссылка;

	Если Не ИспользоватьФильтры Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоРасширеннаяФорма Тогда
		ПодключитьОбработчикОжидания("ПодборТоваров_ВидыНоменклатурыПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
	Иначе
		ПодключитьОбработчикОжидания("ВидыНоменклатурыПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОстаткиТоваров

&НаКлиенте
Процедура ПодборТоваров_ОстаткиТоваровВыборПеред(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТекущаяСтрокаНоменклатуры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицыОстатков = ОстаткиТоваров.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если СтрокаТаблицыОстатков = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрокаТаблицыОстатков.СкладОписание = "Итого по складам" Тогда
		УстановитьВыполнениеОбработчиковСобытия(Ложь);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементоТаблицыФормыИерархияНоменклатуры

&НаКлиенте
Процедура ПодборТоваров_ИерархияНоменклатурыВыборПеред(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Элементы.ИерархияНоменклатуры.Развернут(ВыбраннаяСтрока) Тогда
		Элементы.ИерархияНоменклатуры.Свернуть(ВыбраннаяСтрока);
	Иначе
		Элементы.ИерархияНоменклатуры.Развернуть(ВыбраннаяСтрока);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодборТоваров_ИзменитьВариантНавигацииЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено 
		Или ВариантНавигации = Результат.Значение Тогда
		Возврат;
	КонецЕсли;
	
	ВариантНавигации = Результат.Значение;
	ПодборТоваров_ВариантНавигацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПодборТоваров_ВариантНавигацииПриИзмененииНаСервере()
	
	ПодборТоваровСервер.ПриИзмененииВариантаНавигации(ЭтаФорма);
	Если ЭтоРасширеннаяФорма Тогда
		ИзменитьТекстЗапроса();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетПоступлениеИОтгрузкаТоваров()
	
	Если Не ЕстьПравоДоступаКОтчету Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанныеИнформацииПоСкладам = Элементы.СписокРасширенныйПоискНоменклатура.ТекущиеДанные;
	Если ТекущиеДанныеИнформацииПоСкладам = Неопределено ИЛИ ТекущиеДанныеИнформацииПоСкладам.Ожидается = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ТекущиеДанныеСписка();
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Номенклатура = ТекущиеДанные.Номенклатура;
	Склад        = СкладДляСоединения;
	Отбор        = Новый Структура("Номенклатура", Номенклатура);
	
	Если ЗначениеЗаполнено(Склад) Тогда
		Отбор.Вставить("Склад", Склад);
	КонецЕсли;
	ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии", Отбор, Истина);
	
	ОткрытьФорму("Отчет.ПоступлениеИОтгрузкаТоваров.Форма", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Функция ТекущиеДанныеСписка()
	
	Если Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура Тогда
		ТекущиеДанные = Элементы.СписокРасширенныйПоискНоменклатура.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.СписокСтандартныйПоискНоменклатура.ТекущиеДанные;
	КонецЕсли;
	
	Возврат ТекущиеДанные;
	
КонецФункции

&НаКлиенте
Процедура ПодборТоваров_ПодборТаблицаПриАктивизацииСтрокиОбработчикОжидания()
	
	ПолучитьИнформациюОТовареПриЗакупке(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборТоваров_ВидыНоменклатурыПриАктивизацииСтрокиОбработчикОжидания()
	
	ТекущиеДанные = Элементы.ВидыНоменклатуры.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
	
		ПодборТоваров_ВидыНоменклатурыПриАктивизацииСтрокиПослеНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодборТоваров_ВидыНоменклатурыПриАктивизацииСтрокиПослеНаСервере()

	ПодборТоваровСервер.ПриИзмененииВидаНоменклатуры(ЭтаФорма);
	
	Если СтрНайти(СписокНоменклатура.ТекстЗапроса, "ГрафикПоступленияТоваровОстатки") > 0 Тогда
		Возврат;
	КонецЕсли;
	ИзменитьТекстЗапроса();

КонецПроцедуры

// Получает информацию о товаре - цене закупки и остатках товара.
//
// Параметры:
//	Форма - УправляемаяФорма - форма подбора товаров.
//
&НаКлиенте
Процедура ПолучитьИнформациюОТовареПриЗакупке(Форма) Экспорт
	
	Если Не Форма.ОтображатьОстатки Тогда
		Возврат;
	КонецЕсли;
	
	ОстаткиПоСкладам = Форма.ОстаткиТоваров.ПолучитьЭлементы();
	ОстаткиПоСкладам.Очистить();
	
	ОстаткиПоСкладамПоставщика = Форма.ОстаткиТоваровПоставщика.ПолучитьЭлементы();
	ОстаткиПоСкладамПоставщика.Очистить();
	
	Если Форма.РежимПодбораБезСуммовыхПараметров И Не Форма.ОтображатьОстатки Тогда
		Возврат;
	КонецЕсли;
	
	ХарактеристикиИспользуются = Форма.ТекущаяСтрокаНоменклатуры.ХарактеристикиИспользуются;
	ЭтоТовар = Форма.ТекущаяСтрокаНоменклатуры.ЭтоТовар;
	
	Если ЭтоТовар <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.НавигацияПоНоменклатуреПоставщика Тогда
		
		СтрокаТаблицыНоменклатурыПоставщика = Форма.Элементы[ПодборТоваровКлиентСервер.ИмяСпискаНоменклатурыПоставщикаПоВариантуПоиска(Форма)].ТекущиеДанные;
		Если СтрокаТаблицыНоменклатурыПоставщика = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Номенклатура = СтрокаТаблицыНоменклатурыПоставщика.Номенклатура;
		Если ХарактеристикиИспользуются Тогда
			Характеристика = СтрокаТаблицыНоменклатурыПоставщика.Характеристика;
		КонецЕсли;
		
		ПодборТоваровКлиент.УстановитьТекущуюСтрокуИерархииНоменклатурыПоставщика(Форма);
	Иначе
		Номенклатура = Форма.ТекущаяСтрокаНоменклатуры.Номенклатура;
		Характеристика = Форма.ТекущаяСтрокаХарактеристик.Характеристика;
	КонецЕсли;
		
	Если Не Форма.НавигацияПоХарактеристикам Тогда
		Характеристика = ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка");
	КонецЕсли;

	// Заменим вызов процедуры из общего модуля на собственную для переопределения списка доступных складов.
	ИнформацияОТоваре = ЦенаЗакупкиИОстаткиТовара(Номенклатура, Характеристика, 
		Форма.Соглашение, Форма.Валюта, Форма.Склады);
	
	СтруктураЦена = ИнформацияОТоваре.Цена;
	
	НаименованиеУпаковкиЕдиницыИзмерения = ?(ЗначениеЗаполнено(СтруктураЦена.Упаковка), 
		Строка(СтруктураЦена.Упаковка), 
		Строка(СтруктураЦена.ЕдиницаИзмерения));
	
	Для Каждого СтрокаТекущиеОстатки Из ИнформацияОТоваре.ТекущиеОстатки Цикл
		
		СтрокаОстаткиПоСкладам = ОстаткиПоСкладам.Добавить();
		
		СтрокаОстаткиПоСкладам.Период = ТекущаяДата();
		СтрокаОстаткиПоСкладам.ПериодОписание = НСтр("ru = 'Сейчас'");
		
		СтрокаОстаткиПоСкладам.Доступно = СтрокаТекущиеОстатки.Свободно;
		
		СтрокаОстаткиПоСкладам.ДоступноОписание = ОписаниеДоступногоКоличества(
			СтрокаОстаткиПоСкладам.Доступно,
			НаименованиеУпаковкиЕдиницыИзмерения,
			ХарактеристикиИспользуются,
			Форма.НавигацияПоХарактеристикам Или Форма.НавигацияПоНоменклатуреПоставщика);
		
		СтрокаОстаткиПоСкладам.Склад = СтрокаТекущиеОстатки.Склад;
		СтрокаОстаткиПоСкладам.СкладОписание = Строка(СтрокаТекущиеОстатки.Склад);
		СтрокаОстаткиПоСкладам.СкладДоступенДляВыбора = СкладДоступенДляВыбора(Форма, СтрокаОстаткиПоСкладам.Склад);
		
		СтрокаОстаткиПоСкладамПоставщика = ОстаткиПоСкладамПоставщика.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаОстаткиПоСкладамПоставщика, СтрокаОстаткиПоСкладам);
		
		ПланируемыеОстаткиПоДатам = СтрокаОстаткиПоСкладам.ПолучитьЭлементы();
		ПланируемыеОстаткиПоДатамПоставщика = СтрокаОстаткиПоСкладамПоставщика.ПолучитьЭлементы();
		
		// Вывести планируемые остатки по графику движений товаров.
		Для Каждого СтрокаПланируемыеОстатки Из ИнформацияОТоваре.ПланируемыеОстатки Цикл
			
			Если Не (СтрокаПланируемыеОстатки.Склад = СтрокаОстаткиПоСкладам.Склад) Тогда
				Продолжить;
			КонецЕсли;
			
			// ... в таблицу планируемых остатков по датам.
			СтрокаПланируемыеОстаткиПоДатам = ПланируемыеОстаткиПоДатам.Добавить();
			
			СтрокаПланируемыеОстаткиПоДатам.Период = СтрокаПланируемыеОстатки.Период;
			СтрокаПланируемыеОстаткиПоДатам.ПериодОписание = Формат(СтрокаПланируемыеОстатки.Период, "ДФ=dd.MM.yyyy");
			
			СтрокаПланируемыеОстаткиПоДатам.Доступно = СтрокаПланируемыеОстатки.Доступно;
			
			СтрокаПланируемыеОстаткиПоДатам.ДоступноОписание = ОписаниеДоступногоКоличества(
				СтрокаПланируемыеОстаткиПоДатам.Доступно,
				НаименованиеУпаковкиЕдиницыИзмерения,
				ХарактеристикиИспользуются,
				Форма.НавигацияПоХарактеристикам);
			
			СтрокаПланируемыеОстаткиПоДатам.Склад = СтрокаПланируемыеОстатки.Склад;
			СтрокаПланируемыеОстаткиПоДатам.СкладОписание = "";
			СтрокаПланируемыеОстаткиПоДатам.СкладДоступенДляВыбора = СкладДоступенДляВыбора(Форма, СтрокаПланируемыеОстаткиПоДатам.Склад);
			
			// ... в таблицу планируемых остатков поставщика по датам.
			СтрокаПланируемыеОстаткиПоставщикаПоДатам = ПланируемыеОстаткиПоДатамПоставщика.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПланируемыеОстаткиПоставщикаПоДатам, СтрокаПланируемыеОстаткиПоДатам);
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Вывод итогов по всем складам.
	СвободныеОстаткиПоСкладам = ОстаткиПоВСемСкладам(Номенклатура);
	Если СвободныеОстаткиПоСкладам <> 0 Тогда
		СтрокаОстаткиПоСкладам = ОстаткиПоСкладам.Добавить();
		СтрокаОстаткиПоСкладам.СкладОписание = НСтр("ru = 'Итого по складам'");
		СтрокаОстаткиПоСкладам.Доступно      = СвободныеОстаткиПоСкладам;
		СтрокаОстаткиПоСкладам.ДоступноОписание = ОписаниеДоступногоКоличества(
			СвободныеОстаткиПоСкладам,
			НаименованиеУпаковкиЕдиницыИзмерения, 
			ХарактеристикиИспользуются,
			НавигацияПоХарактеристикам);
		СтрокаОстаткиПоСкладам.СкладДоступенДляВыбора = Ложь;
		СтрокаОстаткиПоСкладам.Период = ТекущаяДата();
		СтрокаОстаткиПоСкладам.ПериодОписание = НСтр("ru = 'Сейчас'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОстаткиПоВСемСкладам(Номенклатура)
	
	// Вывод строки с итогами по всем складам.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	""Итого по складам"" КАК Склад,
		|	ТоварыНаСкладахОстатки.ВНаличииОстаток,
		|	ТоварыНаСкладахОстатки.ВНаличииОстаток - ТоварыНаСкладахОстатки.КОтгрузкеОстаток КАК Свободно
		|ИЗ
		|	РегистрНакопления.ТоварыНаСкладах.Остатки(, Номенклатура = &Номенклатура) КАК ТоварыНаСкладахОстатки
		|ГДЕ
		|	ТоварыНаСкладахОстатки.ВНаличииОстаток <> 0";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Возврат ВыборкаДетальныеЗаписи.Свободно;

	КонецЦикла;
		
	Возврат 0;

КонецФункции

// Возвращает структуру - информацию о цене закупки и остатках товара.
//
// Парамметры:
//	Форма - УправляемаяФорма - форма подбора.
//
// Возвращаемое значение:
//	Структура. Структура с информацией о цене закупки и остатках товара.
//
&НаСервере
Функция ЦенаЗакупкиИОстаткиТовара(Номенклатура, Характеристика, Соглашение, Валюта, Склады) Экспорт
	
	Перем СоставРазделовЗапроса;
	
	Если ЭтоРасширеннаяФорма Тогда
		Склады = Новый СписокЗначений;
		// Определение списка складов.
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Склады.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Склады КАК Склады
			|ГДЕ
			|	Склады.Ссылка В ИЕРАРХИИ(&Склад)";
		
		Запрос.УстановитьПараметр("Склад", ГруппаСкладов);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Склады.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
	ЦенаЗакупки = Новый Структура("Цена, Упаковка, ЕдиницаИзмерения");
	ЦенаЗакупки.Цена = 0;
	ЦенаЗакупки.Упаковка = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
	ЦенаЗакупки.ЕдиницаИзмерения = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	ИспользованиеХарактеристик = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ИспользованиеХарактеристик");
	НесколькоХарактеристик = ИспользованиеХарактеристик <> Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать;

	Запрос.Текст = ПодборТоваровСервер.ТекстЗапросаДоступныхОстатковПоДатамДляПодбора(
		ЗначениеЗаполнено(Характеристика), НесколькоХарактеристик, СоставРазделовЗапроса) 
		+ ПодборТоваровСервер.РазделительПакетаЗапросов()
		+ ПодборТоваровСервер.ТекстЗапросаЦенаЗакупкиТовара(СоставРазделовЗапроса);
	
	Если Не ЗначениеЗаполнено(Характеристика) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{(Номенклатура)}", "И Номенклатура = &Номенклатура");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{(Номенклатура)}", "И Номенклатура = &Номенклатура И Характеристика = &Характеристика");
	КонецЕсли;
	
	Если ПодборТоваровСервер.ЕстьЗначенияЦенНоменклатурыПозжеДатыПодбора(ТекущаяДатаСеанса()) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{ЦеныНоменклатурыПоставщиковСрезПолседнихНаДату}","КОНЕЦПЕРИОДА(&ТекущаяДата, ДЕНЬ)");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{ЦеныНоменклатурыПоставщиковСрезПолседнихНаДату}","");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("Склады", Склады);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Запрос.ВыполнитьПакет();
	
	// Расчет цены закупки товара.
	Коэффициент = 1;
	
	Выборка = Результат[СоставРазделовЗапроса.Найти("ЦенаЗакупкиТовара")].Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Коэффициент = Выборка.Коэффициент;
		ЗаполнитьЗначенияСвойств(ЦенаЗакупки, Выборка);
		
	КонецЕсли;
	
	// Текущие остатки.
	Выборка = Результат[СоставРазделовЗапроса.Найти("ДоступныеТовары")].Выбрать();
	
	ТекущиеОстатки = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Свободно = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Новый Структура("Склад, ВНаличии, Свободно");
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
		
		НоваяСтрока.ВНаличии = НоваяСтрока.ВНаличии / Коэффициент;
		НоваяСтрока.Свободно = НоваяСтрока.Свободно / Коэффициент;
		
		ТекущиеОстатки.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	// Планируемые остатки.
	Выборка = Результат[СоставРазделовЗапроса.Найти("ПланируемыеОстатки")].Выбрать();
	
	ПланируемыеОстатки = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Доступно = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Новый Структура("Склад, Период, Доступно");
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
		
		НоваяСтрока.Доступно = НоваяСтрока.Доступно / Коэффициент;
		
		ПланируемыеОстатки.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	Возврат Новый Структура("ТекущиеОстатки, ПланируемыеОстатки, Цена", ТекущиеОстатки, ПланируемыеОстатки, ЦенаЗакупки);
	
КонецФункции

&НаСервере
Процедура ИзменитьТекстЗапроса()
	
	Если Не ЭтоРасширеннаяФорма Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрНайти(СписокНоменклатура.ТекстЗапроса, "ГрафикПоступленияТоваровОстатки") > 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Документ.Ссылка) И ЗначениеЗаполнено(СкладДляСоединения) Тогда
		СписокНоменклатура.ТекстЗапроса = СтрЗаменить(СписокНоменклатура.ТекстЗапроса, "КОНЕЦ, 1) КАК ЧИСЛО(15, 3)) КАК Доступно", "КОНЕЦ, 1) КАК ЧИСЛО(15, 3)) КАК Доступно,
			|	ЕСТЬNULL(ГрафикПоступленияТоваровОстатки.КоличествоИзЗаказовОстаток, 0) КАК Ожидается");
		СписокНоменклатура.ТекстЗапроса = СтрЗаменить(СписокНоменклатура.ТекстЗапроса, "ПО (КурсыСрезПоследнихВалютаЦены.Валюта = ЦеныНоменклатурыПоставщиков.Валюта)", "ПО (КурсыСрезПоследнихВалютаЦены.Валюта = ЦеныНоменклатурыПоставщиков.Валюта)
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ГрафикПоступленияТоваров.Остатки(, Склад В ИЕРАРХИИ (&Склад)) КАК ГрафикПоступленияТоваровОстатки
			|		ПО СправочникНоменклатура.Ссылка = ГрафикПоступленияТоваровОстатки.Номенклатура");
	ИначеЕсли ЗначениеЗаполнено(СкладДляСоединения) Тогда
		СписокНоменклатура.ТекстЗапроса = СтрЗаменить(СписокНоменклатура.ТекстЗапроса, "0)) КАК ЧИСЛО(15, 3)) КАК Доступно", "0)) КАК ЧИСЛО(15, 3)) КАК Доступно,
			|	ЕСТЬNULL(ГрафикПоступленияТоваровОстатки.КоличествоИзЗаказовОстаток, 0) КАК Ожидается");
		СписокНоменклатура.ТекстЗапроса = СтрЗаменить(СписокНоменклатура.ТекстЗапроса, "Справочник.Номенклатура КАК СправочникНоменклатура", "Справочник.Номенклатура КАК СправочникНоменклатура
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ГрафикПоступленияТоваров.Остатки(, Склад В ИЕРАРХИИ (&Склад)) КАК ГрафикПоступленияТоваровОстатки
			|		ПО СправочникНоменклатура.Ссылка = ГрафикПоступленияТоваровОстатки.Номенклатура");
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает текущую строку иерархии номенклатуры номенклатуры поставщика в форме подбора по закупкам.
//
//	Форма - УправляемаяФорма - форма списка, форма подбора.
//
&НаКлиенте
Процедура УстановитьТекущуюСтрокуИерархииНоменклатурыПоставщика(Форма)
	
	Если Форма.ИспользоватьФильтрНоменклатураПоставщика
		Или Не Форма.НавигацияПоНоменклатуреПоставщика Тогда
		Возврат;
	КонецЕсли;
	
	ИмяСпискаНоменклатуры = ПодборТоваровКлиентСервер.ИмяСпискаНоменклатурыПоставщикаПоВариантуПоиска(Форма);
	
	ТекущаяСтрока = Форма.Элементы[ИмяСпискаНоменклатуры].ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Форма.Элементы[ИмяСпискаНоменклатуры].ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.Элементы.ИерархияНоменклатурыПоставщика.ТекущаяСтрока = ТекущиеДанные.Родитель Тогда
		Возврат;
	КонецЕсли;
	
	Форма.Элементы.ИерархияНоменклатурыПоставщика.ТекущаяСтрока = ТекущиеДанные.Родитель;
	Форма.ТекущаяИерархияНоменклатурыПоставщика                 = ТекущиеДанные.Родитель;
	
КонецПроцедуры

// Возвращает строковое описание доступного количества. Используется при выводе
// строк в таблицу остатков в формах подбора товаров в документ продажи, документ
// закупки.
//
// Параметры
//  КоличествоДоступно (Число) - количество товаров,
//	НаименованиеУпаковкиЕдиницыИзмерения (Строка) - наименование упаковки, единицы измерения,
//	ХарактеристикиИспользуются (Булево) - признак ведения учета по характеристикам у товара,
//	НавигацияПоХарактеристикам (Булево) - признак навигации по характеристикам на форме подбора.
//
// Возвращаемое значение:
//	Строка. Описание доступного количества товаров для текущей строки в форме подбора.
//
&НаКлиенте
Функция ОписаниеДоступногоКоличества(КоличествоДоступно, НаименованиеУпаковкиЕдиницыИзмерения, 
	ХарактеристикиИспользуются, НавигацияПоХарактеристикам)
	
	ДоступноОписание = "";
	
	Если ЗначениеЗаполнено(КоличествоДоступно) Тогда
			ДоступноОписание = Формат(КоличествоДоступно,"ЧДЦ=3") + " " + НаименованиеУпаковкиЕдиницыИзмерения;
	КонецЕсли;
	
	Возврат ДоступноОписание;
	
КонецФункции

// Возвращает признак доступности склада для выбора.
//
// Параметры:
//	Форма - УправляемаяФорма - форма подбора товаров.
//
// Возвращаемое значение:
//	Булево.
//
&НаКлиенте
Функция СкладДоступенДляВыбора(Форма, Склад)

	Возврат Не (Форма.Склады.НайтиПоЗначению(Склад) = Неопределено);

КонецФункции

// Процедура вызывается при изменении флажка "Отображать остатки" на формах подборов.
//
// Параметры:
//	Форма - УправляемаяФорма - форма подбора.
//
&НаКлиенте
Процедура ПриИзмененииОтображенияОстатковПоСкладамДокумента(Форма) Экспорт
	
	Форма.ОтображатьОстатки = Не Форма.ОтображатьОстатки;
	Форма.Элементы.ОстаткиТоваров.Видимость = Форма.ОтображатьОстатки;
	Если ЭтоРасширеннаяФорма Тогда
		Форма.ПодключитьОбработчикОжидания("ПодборТоваров_ПодборТаблицаПриАктивизацииСтрокиОбработчикОжидания",0.1,Истина);
	Иначе
		Форма.ПодключитьОбработчикОжидания("ПодборТаблицаПриАктивизацииСтрокиОбработчикОжидания",0.1,Истина);
	КонецЕсли;
	ПодборТоваровКлиентСервер.УстановитьТекстНадписиОтображатьОстатки(Форма);
	
	Если ПодборТоваровКлиентСервер.ЭтоФормаПодбораВДокументыЗакупки(Форма) Тогда
		
		ПодборТоваровКлиентСервер.УстановитьТекстНадписиОтображатьОстаткиНоменклатурыПоставщика(Форма);
		Форма.Элементы.ОстаткиТоваровПоставщика.Видимость = Форма.ОтображатьОстатки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодборТоваров_УстановитьУсловноеОформлениеДинамическихСписков(Форма, ЭтоФормаПодбораВДокументыЗакупки = Ложь)
	ЭтоПартнер = ПраваПользователяПовтИсп.ЭтоПартнер();
	
	Если Не ЭтоПартнер Тогда
	
		Элемент = УсловноеОформление.Элементы.Добавить();
	
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОстаткиТоваров.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОстаткиТоваров.СкладОписание");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = "Итого по складам";
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ИтогиФон);
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокРасширенныйПоискНоменклатураОжидается.Имя);
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Формат", "ЧДЦ=3");
		Элемент.Оформление.УстановитьЗначениеПараметра("ВыделятьОтрицательные", Истина);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
