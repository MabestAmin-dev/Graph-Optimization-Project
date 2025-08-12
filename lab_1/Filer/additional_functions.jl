#-------------------------------------------------------------------------------
#  Load packages
#-------------------------------------------------------------------------------
using DataFrames, Printf


#-------------------------------------------------------------------------------
# Return 1 if the model has at least one integer variable and 0 if not
#-------------------------------------------------------------------------------

function Integer_model(model)
    intt = 0    
    for xi in all_variables( model )
        if is_integer( xi )
            intt = 1
            break
        end
    end
    return (intt)
end



#-------------------------------------------------------------------------------
# Print the name and value of the variables in an/a integer/mixed integer problem
#-------------------------------------------------------------------------------

function print_integer( model )

    nr_vars1 = length(all_variables(model))
    if nr_vars1 > 0
        var_df =
            DataFrames.DataFrame(variable_int_report(xi) for xi in all_variables( model ))
    
        println(var_df[!,1:2])
    else
        println("no variables")
    end
    
    println()


end

function variable_int_report(xi)
    return (
        variable = name(xi),
        value = value(xi),
    )
end



#-------------------------------------------------------------------------------
# Print the name, value and reduced cost of the variables as well as name, slack value and dual values corresponding to constraints in a continuous problem
#-------------------------------------------------------------------------------
function print_continuous( model )

    report = lp_sensitivity_report( model )

    #display(report)
    nr_vars = length(all_variables(model))
    nr_cons = sum( 1  for (F, S) in list_of_constraint_types(model) ) - 1

    if nr_vars > 0
        var_df =
            DataFrames.DataFrame(variable_con_report(xi,model,report) for xi in all_variables( model ))

        println(var_df[!,1:3])
    else
        println("no variables")
    end

    println()

    if nr_cons > 0
        con_df = DataFrames.DataFrame(
            constraint_con_report(ci,report) for (F, S) in list_of_constraint_types( model ) for
            ci in all_constraints(model, F, S) if F == AffExpr
            );
        # To get correct shadow prices for MAX problems
        if isequal( objective_sense(model) , MOI.MAX_SENSE )
          con_df[!,3]  = -con_df[!,3]
        end
        println(con_df[!,1:3])
    else
        println(" NO CONSTRAINTS")
    end

    # println(var_df[!,1:3])
    # println()
    # println(con_df[!,1:3])

    # println(var_df)
    # println()
    # println(con_df)

    #return var_df, con_df
end



function variable_con_report(xi,model,report)
    return (
        variable = name(xi),
        #LBD = has_lower_bound(xi) ? lower_bound(xi) : -Inf,
        value = value(xi),
        #UBD = has_upper_bound(xi) ? upper_bound(xi) : Inf,
        red_cost    = reduced_cost(xi),
        down        = coefficient(objective_function(model), xi) + report[xi][1],
        obj_coeff   = coefficient(objective_function(model), xi),
        up          = coefficient(objective_function(model), xi) + report[xi][2],
    )
end


function constraint_con_report(ci,report)
    return (
        constraint = name(ci),
        #value = value(ci),
        slack   = normalized_rhs(ci) - value(ci),
        #dual    = shadow_price(ci),
        dual    = dual(ci),
        down    = normalized_rhs(ci) + report[ci][1],
        rhs     = normalized_rhs(ci),
        up      = normalized_rhs(ci) + report[ci][2],
    )
end



#-------------------------------------------------------------------------------
# Print sudoku
#-------------------------------------------------------------------------------
function print_sudoku(X=[])

    if isempty( X )
      X = zeros(9,9)
    end
  
    str = "+-------+-------+-------+\n"
  
    for row in 1:9
      if mod( row , 3) == 1
        @printf("%s",str);
      end
      for col in 1:9
        if mod( col , 3) == 1
          @printf("| ")
        end
        #@printf("%i", X[row,col] )
        nr = X[row,col]
        if nr > 0
          @printf("%i ", nr )
        else
          @printf(". ")
        end
      end
      @printf("|\n")
    end
    @printf("%s",str);
  
  end



#-------------------------------------------------------------------------------
# Print chess
#-------------------------------------------------------------------------------
function print_chess( X=[] )

    if isempty( X )
      X = zeros(8,8)
    end
  
    m,n = size(X)
  
    str = repeat("+---",n) * "+\n"
  
    for row in 1:m
      @printf("%s",str);
      for col in 1:n
        nr = X[row,col]
        if nr > 0
          symbol = "X"
        else
          #symbol = "."
          symbol = " "
        end
        @printf("| %s ", symbol)
      end
      @printf("|\n")
    end
    @printf("%s",str);
  
  end
  #-------------------------------------------------------------------------------