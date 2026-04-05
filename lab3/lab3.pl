:- encoding(utf8).
% ЛАБОРАТОРНАЯ РАБОТА №3: Программирование в терминах образцов

% 1. ПРАВИЛА ГЕНЕРАЦИИ (База знаний образцов)
% Автоматически сопоставляет входящий документ с этими образцами.

% Образец 1: Командировка (trip). 
% Если страна визовая, нужна заявка на визу и страховка.
generate_supp(trip(Employee, Country), [visa_request(Employee, Country), insurance(Employee)]) :-
    member(Country, [usa, uk, germany, france, japan]). % Список визовых стран

% Если страна безвизовая, нужна только страховка.
generate_supp(trip(Employee, Country), [insurance(Employee)]) :-
    \+ member(Country, [usa, uk, germany, france, japan]).

% Образец 2: Договор (contract). 
% Если сумма > 100 000, требуется налоговая проверка и виза фин. директора.
generate_supp(contract(Company, Amount), [tax_check(Company), fin_director_approval]) :-
    Amount > 100000.

% Если сумма <= 100 000, достаточно только налоговой проверки.
generate_supp(contract(Company, Amount), [tax_check(Company)]) :-
    Amount =< 100000.

% Образец 3: Заявление на отпуск (vacation).
% Если отпуск 14 дней и более, нужен приказ о замещении и виза HR.
generate_supp(vacation(Employee, Days), [hr_approval(Employee), replacement_order(Employee)]) :-
    Days >= 14.

% Если менее 14 дней, нужна только виза HR.
generate_supp(vacation(Employee, Days), [hr_approval(Employee)]) :-
    Days < 14.

% Образец по умолчанию (Catch-all). 
% Если документ неизвестного формата, дополнительные документы не требуются.
generate_supp(_, []).


% 2. ДВИЖОК ИМИТАЦИОННОГО МОДЕЛИРОВАНИЯ
% Обрабатывает очередь документов и формирует итоговый пакет.

% Базовый случай: очередь пуста -> итоговый список пуст.
simulate([], []).

% Рекурсивный шаг: берем первый документ (Doc), сопоставляем с образцом,
% генерируем дополнения (Supps), рекурсивно обрабатываем остаток (Rest)
% и склеиваем все в один финальный список (FinalDocs).
simulate([Doc | Rest], FinalDocs) :-
    generate_supp(Doc, Supps),
    simulate(Rest, ProcessedRest),
    append([Doc | Supps], ProcessedRest, FinalDocs).


% 3. ТЕСТОВЫЙ СЦЕНАРИЙ (Для удобного запуска)
run_simulation :-
    % Формируем тестовый поток входящих документов
    IncomingQueue = [
        contract(gazprom, 150000),      % Крупный договор
        vacation(ivanov, 7),            % Короткий отпуск
        trip(petrov, japan),            % Визовая командировка
        memo(sidorov, 'fix printer')    % Неизвестный документ (служебная записка)
    ],
    
    write('--- ИМИТАЦИОННОЕ МОДЕЛИРОВАНИЕ ЗАПУЩЕНО ---'), nl,
    write('Входящий поток документов:'), nl,
    print_docs(IncomingQueue), nl,
    
    % Запускаем симуляцию
    simulate(IncomingQueue, Output),
    
    write('--- РЕЗУЛЬТАТ (Сформированный пакет документов) ---'), nl,
    print_docs(Output).

% Вспомогательный предикат для красивого вывода списка в консоль столбиком
print_docs([]).
print_docs([H|T]) :-
    write(' -> '), write(H), nl,
    print_docs(T).