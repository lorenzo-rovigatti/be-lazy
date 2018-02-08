---

# Coding

## Exposing c/c++ code to Python with Boost Python

On Ubuntu (and, I suppose, on other Debian-related distros) Boost Python requires the `libboost-python-dev` package.

Here is a simple example. Copy the following c++ code to the "Foo.cpp" file:

	#include <iostream>
	#include <boost/python.hpp>

	class Foo {
	public:
		Foo() {

		}
		virtual ~Foo() {

		}
		void print_something(std::string something) {
		        std::cout << something << std::endl;
		}
		void print_special(std::string special) {
			std::cout << "special: " << special << std::endl;
		}
	};

	BOOST_PYTHON_MODULE(foo) {
		boost::python::class_<Foo>("Foo")
		        .def("print_something", &Foo::print_something);
	}

Now that the c++ code is ready and we have decided the interface that should be exposed to python (in this case a class with the default constructor and one of its two public methods), we compile everything in a shared library:

	g++ -fPIC -I/usr/include/python2.7  -c Foo.cpp -o foo.o
	g++ -shared -o foo.so foo.o -lpython2.7 -lboost_python -lboost_system

We have nothing else to do: the library is now freely importable by python:

	>>> import foo
	>>> f = foo.Foo()
	>>> f.print_something("Hello, world!")
	Hello, world!
	>>> f.print_special("My special text")
	Traceback (most recent call last):
	  File "<stdin>", line 1, in <module>
	AttributeError: 'Foo' object has no attribute 'print_special'

As can be seen from the error above, only the methods, classes and functions that are explicitly mentioned in the exporting function can be accessible from python.

**Nota Bene:** The name of the python module (which is set by the only argument of the `BOOST_PYTHON_MODULE` macro) **must** match the name of the library file or python will complain by throwing a `ImportError: dynamic module does not define init function` exception. 

Boost python has a lot of features (for instance, it supports templates, inheritance, *etc.*). Check out the [documentation](http://www.boost.org/doc/libs/1_66_0/libs/python/doc/html/) for more complex examples and for the reference manual.

### Speeding-up compilation and reducing memory consumption

Compilation time and memory footprint of large projects can become an issue. These problems can be mitigated by a simple *divide et impera* procedure. For instance, take a project containing two classes, `Foo` and `Bar`. Each class has its own `.h` and `.cpp` files. Then, at the end of each `.cpp` file we put a function that performs the actual exporting. For example, burrowing from the previously-defined `Foo` class one might have:

	void export_foo() {
		boost::python::class_<Foo>("Foo")
		        .def("print_something", &Foo::print_something);
		/* export here everything that needs to be exported for this compilation unit */
	}

Now we round up all these exporting function in a single file `mylib.cpp` where the actual module-creation is carried out. For the specific case considered here, the content of such a file would be

	#include "Foo.h"
	#include "Bar.h"
	#include <boost/python.hpp>

	void export_foo();
	void export_bar();

	BOOST_PYTHON_MODULE(mylib) {
		export_foo();
		export_bar();
	}

### Compiling with CMake

Compiling python modules with CMake is straightforward. First of all, we need to find all the packages that are required to correctly compile the module:

	FIND_PACKAGE( PythonLibs 2.7 REQUIRED )
	INCLUDE_DIRECTORIES( ${PYTHON_INCLUDE_DIRS} )

	FIND_PACKAGE( Boost COMPONENTS python REQUIRED )
	INCLUDE_DIRECTORIES( ${Boost_INCLUDE_DIR} )

Note that you need to choose the python version you want to create bindings for.
Now create a new target, ensuring that is linked against the right libraries (here we assume that the source files are listed in `mylib_SOURCES`):

	ADD_LIBRARY(mylib SHARED ${mylib_SOURCES})
	TARGET_LINK_LIBRARIES(mylib ${Boost_LIBRARIES} ${PYTHON_LIBRARIES})

And do not forget to ensure that no prefixes are added to the library name, lest python will refuse to import the module:

	SET_TARGET_PROPERTIES(mylib PROPERTIES PREFIX "")

On Mac Os X, dynamic libraries have extensions ".dylib". Unfortunately, some python installations do not recognized those as modules. A workaround might be:

	IF(APPLE)
		SET_TARGET_PROPERTIES(mylib PROPERTIES SUFFIX ".so")
	ENDIF(APPLE)
	
**Tip:** if you are using the Boost logging facilities, you will need to declare the `BOOST_LOG_DYN_LINK` macro or python will complain. This can be done with

	ADD_DEFINITIONS(-DBOOST_LOG_DYN_LINK)
