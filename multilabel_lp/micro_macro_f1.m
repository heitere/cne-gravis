function [micro_f1, macro_f1] = micro_macro_f1(y_pred, y_true)
    y_pred = full(y_pred);
    y_true = full(y_true);
    
    zero_column = find(sum(y_pred, 1) == 0 | sum(y_true, 1) == 0);
    y_pred(:, zero_column) = [];
    y_true(:, zero_column) = [];
        
    d = size(y_pred, 2);
    
    tp = sum(y_pred & y_true, 1);
    fp = sum(y_pred, 1) - tp;
    fn = sum(y_true, 1) - tp;
    
    micro_p = sum(tp)/(sum(tp) + sum(fp));
    micro_r = sum(tp)/(sum(tp) + sum(fn));    
    micro_f1 = 2 * (micro_p * micro_r)/(micro_p + micro_r);
    
    macro_p = sum(tp./(tp + fp))/d;
    macro_r = sum(tp./(tp + fn))/d;    
    macro_f1 = 2*(macro_p * macro_r)/(macro_p + macro_r);
end