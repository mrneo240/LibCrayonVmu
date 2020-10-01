# Needed so we can use scons stuff like builders
from SCons.Script import *

def create_builders(our_vars):
	env = Environment(
		ENV = os.environ,
		CC = 'kos-cc',
		CXX = 'kos-c++',
		AR = 'kos-ar',
	)

	# Making sure we use the right prefix and suffix
	env['LIBPREFIX'] = 'lib'
	env['LIBSUFFIX'] = '.a'
	env['OBJSUFFIX'] = '.o'	# Windows has .obj
	env['PROGSUFFIX'] = '.elf'

	# Fix this later, here's a hack for now
	env['KOS_BASE'] = env['ENV']['KOS_BASE']
	env['KOS_GENROMFS'] = env['ENV']['KOS_GENROMFS']

	# Location of IP.BIN
	if 'IP_BIN_DIR' in our_vars:
		env['IP_BIN_DIR'] = our_vars['IP_BIN_DIR'] + 'IP.BIN'

	# Ensure CRAYON_SF_BASE is set
	if 'CRAYON_SF_BASE' in our_vars:
		env['CRAYON_SF_BASE'] = our_vars['CRAYON_SF_BASE']
		env.AppendUnique(CPPPATH = ['$CRAYON_SF_BASE/include/'])
	else:
		print('CRAYON_SF_BASE is missing, please add the path')
		Exit(1)

	env['CODE_DIR'] = 'src'
	env['CDFS_DIR'] = 'cdfs'
	if 'PROG_NAME' in our_vars:
		env['PROG_NAME'] = our_vars['PROG_NAME']

	#Add in some cflags if you want
	if 'DEBUG' in our_vars and our_vars['DEBUG'] == True:
		# Wformat level 2 has extra checks over standard.
		# no-common is where two files define the same global var when they should be seperate
		# g3 is like g, but it includes macro information
		env.AppendUnique(CPPFLAGS = ['-g3', '-Wall', '-Wformat=2', '-fno-common'])

	# Enables GCC colour (Since it normally only does colour for terminals and scons is just an "output")
	# Major, Minor, Patch version numbers
	colour_version = [4, 9, 0]
	our_version = list(map(int, env['CCVERSION'].split('.')))
	if all([a >= b for a, b in zip(our_version, colour_version)]):
		env.AppendUnique(CCFLAGS = ['-fdiagnostics-color=always'])

	return env
