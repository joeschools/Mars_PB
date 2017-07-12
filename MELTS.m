function [ output ] = MELTS(f,p,b)
%MELTS Runs the alphamelts program
%   f: Settings text file
%   p: output path
%   b: batchfile

addpath('/Users/jschools/bin')
perl('run_alphamelts.command','-f', f,'-p', p,'-b', b)


end
