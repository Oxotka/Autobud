﻿
&НаКлиенте
Процедура ПользователиЧеков_ВыбранныеПользователиВыборПосле(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ВыбранныеПользователи.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Закрыть(ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиЧеков_ВыбратьВместо(Команда)
	
	ТекущиеДанные = Элементы.ВыбранныеПользователи.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Закрыть(ТекущиеДанные.Значение);
	Иначе
		Закрыть(Пользователь);
	КонецЕсли;
	
КонецПроцедуры
