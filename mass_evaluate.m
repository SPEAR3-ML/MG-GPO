function f=mass_evaluate(f, M, V)
%evaluate objectives for multiple chromosome in parallel by submitting jobs
%to LSF. Modify function submit_job, check_job and get_job_data to use.
%
%f,  N x (V+M), chromosome
%M,  integer, number of objectives
%V,  integer, number of variables
% created 10/12/2011, Xiaobiao Huang
%

N = size(f,1);
global g_cnt g_data

for i=1:N
    x = f(i,1:V);
    if 0
        obj1 = func_obj4(x);
        [obj2,p] = func_Rosenbrock(x);
    elseif 1
        [obj1,obj2,p] = func_ZDT2(x);
    end
    
    global g_sigy;
    y1 = obj1;
    y2 = obj2;
%     y1 = log(obj1);
%     y2 = log(obj2);
    
    obj1 = obj1+g_sigy*randn;
    obj2 = obj2+g_sigy*randn;

    global g_cnt g_data
    g_cnt = g_cnt+1;
    g_data(g_cnt,:) = [g_cnt, p(:)' y1,y2,obj1,obj2];


    if mod(g_cnt,10)==0
        [g_cnt, x(:)', obj1 obj2]
    end
    
    f(i,V + 1: M + V) = [obj1,obj2];
end


