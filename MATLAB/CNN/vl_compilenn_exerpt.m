% For the cudaMethod='nvcc'
if opts.enableGpu && strcmp(opts.cudaMethod,'nvcc')
  flags.nvcc = flags.cc ;
  flags.nvcc{end+1} = ['-I"' fullfile(matlabroot, 'extern', 'include') '"'] ;
  flags.nvcc{end+1} = ['-I"' fullfile(matlabroot, 'toolbox','distcomp','gpu','extern','include') '"'] ;
  flags.nvcc{end+1} = opts.cudaArch ; % Add cudaArch agument to complier arguments / KN 2013-03-30
  if opts.debug
    flags.nvcc{end+1} = '-O0' ;
  end
  flags.nvcc{end+1} = '-Xcompiler' ;
  switch arch
    case {'maci64', 'glnxa64'}
      flags.nvcc{end+1} = '-fPIC' ;
    case 'win64'
      flags.nvcc{end+1} = '/MD' ;
      check_clpath(); % check whether cl.exe in path
  end
end