elem(w,window,root).

    %%%%%%%%%%%%%%%%%%%%%%%%
    % Grid
    %%%%%%%%%%%%%%%%%%%%%%%%
    elem(ota,container,w).
    attr(ota,child_layout,grid).
    attr(ota,width,100).
    attr(ota,height,100).

        %%%%%%%%%%%%%%%%%%%%%%%%
        % Cell dropdown
        %%%%%%%%%%%%%%%%%%%%%%%%
        %elem(dd(X,Y),dropdown_menu,clinota):-cave((X,Y)).
        attr(dd(X,Y),width,50):-cave((X,Y)).
        attr(dd(X,Y),height,50):-cave((X,Y)).
        attr(dd(X,Y),grid_column,X):-cave((X,Y)).
        attr(dd(X,Y),grid_row,Y):-cave((X,Y)).
        attr(dd(X,Y),class,("border-dark";"bg-primary")):-cave((X,Y)).
        % attr(dd(X,Y),class,("opacity-100";"disabled";"fw-bold";"text-dark")):-cave((X,Y)).
        %attr(dd(X,Y),class,("text-primary")):-_clinguin_assume(cave((X,Y)), true).
        %attr(dd(X,Y),class,("text-info")):-_all(sudoku(X,Y,V)), not _clinguin_assume(sudoku(X,Y,V), true).
        %attr(dd(X,Y),selected,V):-_all(sudoku(X,Y,V)).
        %attr(dd(X,Y),selected,V):-sudoku(X,Y,V), _clinguin_browsing.

            %%%%%%%%%%%%%%%%%%%%%%%%
            % Cell items
            %%%%%%%%%%%%%%%%%%%%%%%%
            %elem(remove(X,Y), dropdown_menu_item, dd(X,Y)):-cave((X,Y)).
            % attr(remove(X,Y), icon, ("fa-ban";"text-info")):-pos(X,Y).
            % when(remove(X,Y), click, call, remove_assumption_signature(sudoku(X,Y,any))):-pos(X,Y).

            % elem(ddi(X,Y,V),dropdown_menu_item,dd(X,Y)):-pos(X,Y), val(V).
            % attr(ddi(X,Y,V),label,V):-pos(X,Y), val(V).
            % attr(ddi(X,Y,V),class,("text-danger";"disabled")):-pos(X,Y), val(V), not _any(sudoku(X,Y,V)).
            % when(ddi(X,Y,V),click,call,add_assumption(sudoku(X,Y,V),true)):-pos(X,Y), val(V).


%%%%%%%%%%%%%%%%%%%%%%%%
% Menu bar
%%%%%%%%%%%%%%%%%%%%%%%%
elem(menu_bar, menu_bar, w).
attr(menu_bar, title, "Wumpus Observe Think Act Loop").
attr(menu_bar, icon, "fa-table-cells").

    % elem(menu_bar_clear, button, menu_bar).
    % attr(menu_bar_clear, label, "Clear").
    % attr(menu_bar_clear, icon, "fa-trash").
    % attr(menu_bar_clear, class, ("btn-outline-danger";"border-0")).
    % when(menu_bar_clear, click, callback, clear_assumptions).

    % elem(menu_bar_select, button, menu_bar).
    % attr(menu_bar_select, label, "Select solution").
    % attr(menu_bar_select, icon, "fa-hand-pointer").
    % when(menu_bar_select, click, callback, select).

    % elem(menu_bar_next, button, menu_bar).
    % attr(menu_bar_next, label, "Next").
    % attr(menu_bar_next, icon, "fa-forward-step").
    % when(menu_bar_next, click, callback, next_solution).
