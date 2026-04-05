% Базовый предикат для генерации цифр
num(X) :- member(X, [0,1,2,3,4,5,6,7,8,9]).

% Оптимизированный генератор 3 цифр, дающих в сумме S
gen3(S, A, B, C) :-
    num(A),
    S1 is S - A,
    S1 >= 0, S1 =< 18, % Отсекаем тупиковые ветви (две цифры не дадут в сумме больше 18)
    num(B),
    C is S1 - B,
    num(C). % Проверяем, что C является допустимой цифрой

% Основной предикат: перебираем суммы от 0 до 27 и генерируем части билета
lucky_optimal([A, B, C, D, E, F]) :-
    between(0, 27, S), % Встроенный предикат перебора суммы от 0 до 27
    gen3(S, A, B, C),
    gen3(S, D, E, F).

% Подсчет общего количества счастливых билетов
count_optimal(N) :-
    findall(Ticket, lucky_optimal(Ticket), Tickets),
    length(Tickets, N).

% Подсчет счастливых билетов математическим путем
count_math(Total) :-
    findall(Ways, (
        between(0, 27, S),
        findall(1, gen3(S, _, _, _), L), % Находим все комбинации для одной половины
        length(L, Ways)                  % Считаем их количество
    ), WaysList),
    sum_squares(WaysList, 0, Total).

% Вспомогательный предикат для суммы квадратов
sum_squares([], Acc, Acc).
sum_squares([H|T], Acc, Total) :-
    Acc1 is Acc + H * H,
    sum_squares(T, Acc1, Total).