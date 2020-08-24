make-extension: jwrap.pyx
	env CFLAGS="-std=c++11 -DNDEBUG -DJUCE_GLOBAL_MODULE_SETTINGS_INCLUDED" python setup.py build_ext --inplace --force