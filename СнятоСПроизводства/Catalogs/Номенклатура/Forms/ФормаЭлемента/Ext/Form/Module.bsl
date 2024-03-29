﻿#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Снято_АБ_СнятоСПроизводстваПриИзмененииПеред(Элемент)
	
	ТекстСнятоСПроизводства = ТекстСнятоСПроизводства();
	Если Объект.СнятоСПроизводства И НЕ СтрНайти(Объект.Наименование, ТекстСнятоСПроизводства) Тогда
		Объект.Наименование = Объект.Наименование + " " + ТекстСнятоСПроизводства;
	ИначеЕсли НЕ Объект.СнятоСПроизводства И СтрНайти(Объект.Наименование, ТекстСнятоСПроизводства) Тогда
		Объект.Наименование = СокрЛП(СтрЗаменить(Объект.Наименование, ТекстСнятоСПроизводства, ""));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ТекстСнятоСПроизводства()
	
	Возврат НСтр("ru='(Товар снят с производства)'");
	
КонецФункции

#КонецОбласти