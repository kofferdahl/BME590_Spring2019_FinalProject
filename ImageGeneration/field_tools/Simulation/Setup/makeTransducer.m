function tx = makeTransducer(params,impulse, excitation)
%makeTransducer: makes a linear array transducer and sets the
% impulse/excitation signals.
%
% Syntax:  tx = makeTransducer(params, impulse, excitation)
%
%
% Inputs:
%    params: Params structure containing necessary Tx info
%    impulse: Impulse response of transducer
%    excitation: Excitation signal to be applied to tranducer
%
% Outputs:
%    tx: Transducer handle
%
% Other m-files required: Field_II library
% Subfunctions: none
% MAT-files required: none

% Author: Katelyn Offerdahl
% Email address: katelyn.offerdahl@duke.edu
% January 2019; Last revision: 25-January-2019


n_subx = 1;
n_suby = 10;

tx = xdc_linear_array(params.num_elem, params.width, params.height, ...
                        params.kerf, n_subx, n_suby, params.focus);
xdc_impulse(tx, impulse)
xdc_excitation(tx, excitation)

end

