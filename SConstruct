# Import our helper functions
import builder_functions as bf

# Create the environments
our_vars = dict()
our_vars['CRAYON_SF_BASE'] = './'
envs = bf.create_builders(our_vars)

SConscript('SConscript', exports = 'envs')
