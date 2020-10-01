Import('env')

build_dir = 'build/'
env.VariantDir(build_dir, 'src', duplicate=0)	# Kind of moves over the processing for the code
												# directory to our build dir duplicate=0 means it
												# won't duplicate the src files

prog_files = Glob(build_dir + '/*.c') # We have to specify the build path instead of the real one

# We override CPPPATH our output is nice
lib = env.Library(
	target = 'lib/libcrayon_vmu',
	source = prog_files,
	CPPPATH = '${CRAYON_SF_BASE}/include/crayon_vmu'
)

Return('lib')
