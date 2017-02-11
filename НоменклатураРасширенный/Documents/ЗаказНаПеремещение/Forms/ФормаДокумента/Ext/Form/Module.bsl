﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура Номенклатура_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ПараметрыКорзины") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Склад") Тогда
		Объект.СкладОтправитель  = Параметры.Склад;
	КонецЕсли;
	
	ПараметрыКорзины = Параметры.ПараметрыКорзины;
	Если ПараметрыКорзины.Свойство("АдресКорзиныВХранилище") И ЗначениеЗаполнено(ПараметрыКорзины.АдресКорзиныВХранилище) Тогда
		ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(ПараметрыКорзины.АдресКорзиныВХранилище);
		Объект.Товары.Загрузить(ТаблицаДляЗагрузки);
		ПерезаполнитьРеквизитыТовары = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ПриОткрытииПеред(Отказ)
	
	Если ПерезаполнитьРеквизитыТовары Тогда
		ПересчитатьТоварыИзКорзиныНаКлиенте();
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ОбработкаОповещенияПеред(ИмяСобытия, Параметр, Источник)
	
	Если Источник = ЭтотОбъект Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = "ДополнитьТовары" И Параметры.КлючНазначенияИспользования = "Корзина" Тогда
		Если Параметр.Свойство("ИмяДокумента") И Параметр.ИмяДокумента = "ЗаказНаПеремещение" Тогда
			ДополнитьТоварыНаСервере(Параметр.АдресКорзиныВХранилище);
			ПересчитатьТоварыИзКорзиныНаКлиенте();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПересчитатьТоварыИзКорзиныНаКлиенте()
	
	Для Каждого СтрокаТовары Из Объект.Товары Цикл
		
		Номенклатура_ПриИзмененииНоменклатуры(СтрокаТовары);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ПриИзмененииНоменклатуры(СтрокаТовары)

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", СтрокаТовары.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", СтрокаТовары.Упаковка);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПроверитьЗаполнитьОбеспечение",
		Новый Структура("ЗаполнитьОбособленно", Ложь));
	СтруктураДействий.Вставить("ПроверитьЗаполнитьНазначение");
	СтруктураДействий.Вставить("ПриИзмененииТипаНоменклатурыИлиВариантаОбеспечения",
		Новый Структура("ЕстьРаботы, ЕстьОтменено", Ложь, Истина));
	
	ПараметрыПроверкиСерий = Новый Структура("Склад, ПараметрыУказанияСерий");
	ПараметрыПроверкиСерий.Склад = Новый Структура("Отправитель, Получатель", Объект.СкладОтправитель, Объект.СкладПолучатель);
	ПараметрыПроверкиСерий.ПараметрыУказанияСерий = ПараметрыУказанияСерий;
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", ПараметрыПроверкиСерий);
	
	Если КонтролироватьАссортимент Тогда
		СтруктураПроверкиАссортимента = АссортиментКлиентСервер.ПараметрыПроверкиАссортимента();
		СтруктураПроверкиАссортимента.Ссылка = Объект.Ссылка;
		СтруктураПроверкиАссортимента.Склад = Объект.СкладПолучатель;
		СтруктураПроверкиАссортимента.Дата = ?(ЗначениеЗаполнено(Объект.ЖелаемаяДатаПоступления), Объект.ЖелаемаяДатаПоступления, Объект.Дата);
		СтруктураПроверкиАссортимента.ТекстСообщения = НСтр("ru = 'Товар %1 не включен в ассортимент магазина-получателя. Заказывать его не рекомендуется.'");
		СтруктураПроверкиАссортимента.ИмяРесурсаАссортимента = "РазрешеныЗакупки";
		СтруктураПроверкиАссортимента.ПровереноМожноДобавлять = Истина;
		СтруктураПроверкиАссортимента.РазрешатьДобавление = Истина;
		
		СтруктураДействий.Вставить("ПроверитьАссортиментСтроки", СтруктураПроверкиАссортимента);
	КонецЕсли;

	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "Товары"));

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(СтрокаТовары, СтруктураДействий, КэшированныеЗначения);
	ОбеспечениеКлиент.ЗаполнитьСлужебныеРеквизиты(Объект.Товары, ДатаОтгрузкиОбязательна, СкладОбязателен);

КонецПроцедуры

&НаСервере
Процедура ДополнитьТоварыНаСервере(АдресКорзиныВХранилище)
	
	ИсходнаяТаблица = Объект.Товары.Выгрузить();
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресКорзиныВХранилище);
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаДляЗагрузки, ИсходнаяТаблица);
	Объект.Товары.Загрузить(ИсходнаяТаблица);
	
КонецПроцедуры

#КонецОбласти
