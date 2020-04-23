function[rand_array]=randelement(array,n)

%RANDELEMENT Random Element.
%
%  RANDELEMENT(ARRAY,N) returns a row of N elements, selected at random
%  (and with replacement) from ARRAY.
%
%  EXAMPLES:
%
%    randelement([0:9],5)
%      may return [4 8 8 5 2]
%
%    randelement({'a' 'b' 'c' 'd' 'e' 'f'},2)
%      may return {'f' 'd'}
%
%  VERSION DATE: 2005.04.24
%  MATLAB VERSION: 7.0.1.24704 (R14) Service Pack 1
%
%  See also RAND.

%{
%REVISION HISTORY:
%2005.04.24: Made minor update to comments.
%2005.04.20: Fixed error in comments.
%2004.12.28: Original release.

%KEYWORDS:
%rand, random, element
%}

%--------------------------------------------------------------------------

%% Generate indices of random elements from array, and select the elements.

indices=ceil(rand(1,n)*numel(array));
rand_array=array(indices);

%--------------------------------------------------------------------------
