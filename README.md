# KCHackerBooksSwift

HackersBook es un proyecto desarrollado en Swift, compatible para dipositios iOS (iPhone y iPad). El propósito del proyecto es el de aplicar los conocimientos adquiridos en fundamentos de iOS (fundiOS), para el desarrrollo de una applicación que sirva como lector libros en PDF. 

En primer lugar se realiza una descarga de un JSON y se guarda en local.El archivo JSON, las URLs de los libros y recursos adicionales como son las imágenes de sus portadas. Una vez descargado el archivo JSON, se procede a descargar los libros y los recursos adicionales necesarios.

Finalizado el proceso de descarga, se tienen todos los archivo necesarios en local y se le proesenta al usuario en forma de tabla para que pueda acceder a ellos de forma fácil y sencilla.

## Modelo

Para poder trabajar con los datos y realizar trnasformaciones, odenaciones, comparaciones, etc de los mismos; es necesario definir el modelo de nuestra aplicación. En este caso, nuestro modelo se compone principalmente de dos clases la clase BVCBook que define lo que es el libro en cuestión y BVCLibrary que será nuestra biblioteca de libros.

#### BVCBook

Es la clase que define nuestro objeto "Libro".

##### Parámetros
	Párametro	|	Tipo		|	Descripción
	------------|---------------|---------------
	title 		|	String		|	Nombre del libro.
    authors		|	[String]?	|	Array con los autores.
    tags        |   [String]?	|	Array con las temáticas.
    image       |   UIImage?	|	Imagen de portada.
    pdfURL      |   NSURL		|	URL donde está el archivo PDF.
    isFavourite	|	BOOL		|	Parámetro que define si es un libro favorito para el usuario o no.	

##### Métodos 

###### Metódo description
Se ha sobre escrito para que devuleva una String con el título y los autores del libro.

###### Metódos de comparación y ordenación

Se han sobre escrito los metodos de igualación y comparación utilizando proxies para ello. La comparación se realiza en base a título, autores y url del libro, mientras que la ordenación se realiza tenienedo en cuenta el título del libro.


#### BVCLibrary
Clase que define el conjunto de libros que compoen la biblioteca.

##### Parámetros
	Párametro	|	Tipo		|	Descripción
	------------|---------------|---------------
	books 		|	[BVCBook]	|	Array de libros que compoene la biblioteca.
	tags		|	[String]?	|	Array de cadenas con todas las temáticas que existen en la biblioteca.

##### Métodos

###### Metódo de ordenación

Se ha creado un método llamado sortByName para que a partir del array de libros los ordena de forma alfabética por el nombre del libro, y otro llamado sortByTags que ordena los libros según la temática.

###### Metódo de cuantificacion y clasificación

Hay de por sí una propiedad computada que develve el número de libros totales en la biblioteca. Sin embargo, se han creado dos métodos uno (booksCountForTag) que devuelve la catidad de libros para una temática en concreto y otro (booksForTag) que devuleve los libros que corresponden a una temática.

###### Otros metódos

Se han creado una serie de métodos que proporcionan ciertas utilidades adicionales. El método bookAtIndexForTag, devuelve un libro del array para una temática concreta; por otro lado el método bookIndexForDescription busca un libro segúnuna descripción dada y finalmente se ha creado el método defineFavoriteBooks para establecer que libros son los favoritos del usuario.

#### BVCHBookErrors

Esta clase, corresponde a un enum en el que se recogen todos los errores que puede producir la aplicación. Estos elementos del tipo ErrorType, nos permitirán delimitar que tipo de error ha ocurrido en un moemnto dado.

### Preguntas (Modelo)

#### ¿Donde guardarías ls imágenes de portada y los pdf?

Actualmente, en la aplicación se realiza la descarga del JSON y se guarda en la carpeta Documents de nuestra aplicación. Posteriormente, para la descarga de las imágenes y los PDFs se han creado dentro de esa misma carpeta documents dos directorios uno para cada tipo de archivo. A pesar de haberse realizado de esta forma (porque no se ha estudiado aún otros modos de persistencia), considero que una mejor opción sería la de utilizar un sistema de persistencia más avanzado como una pequeña base de datos SQLite o Core Data, a ser posible esta segunda. Esto permitiría guardar ya los objetos, haciendo que no fuera necesario guardar el JSON, además Core Data se encargaría de gestionar de forma automágica las imágenes y los archivos dadndolé una URL relativa si fuera necesario. En nuestro caso, la aplicación mediante un método desarrollado se encarga de la descarga de los archivos y de guardar la URL relativa en el JSON en lugar del la URL web.

## Procesado del JSON

El procesado del JSON, consiste en una vez descargado JSON transformar los datos que hay en el archivo a objetos con los que podamos trabajar. Para ello, la clase NSJSONSerailization nos permite convertir esos datos a un array de diccionarios; una vez obtenidos estos diccionarios pademos coger los datos de ellos y guardarlos en objetos de tipo BVCBook.

### Preguntas (Procesado JSON)

#### ¿Con qué modos podemos utilizar utilizando NSJSONSerailization?

NSJSONSerliazation no devuleve un objeto de tipo genérico como es AnyObject, para poder determinar realmente el tipo de objeto que obtenemos del JSON la clase NSSerailization nos permite utilizar el método iKindOfClass que permite comprobar si el objeto devuelto es de una clase en concreto. Sin embargo, hay otro modos en los que se puede trabajar como es el caso del casteo para ello se utiliza el término as para realizar la conversion de un objeto a otro perteneciente a una clase concreta para poder utilizarlo en nuestro caso se debe definir como opcional as? ya que si no se puede castear devolverá un nil.

## Tabla de libros

Esta tabla representa nuestra biblioteca, se trata de todos los libros que se tienen separados según su temática. En este caso se ha customizado las celdas de la tabla para que además del título y la portada del libro aparezca una imagen que indica se se trata de un favorito o no. Además en primer lugar siempre se encuentran los favoritos y luego todos los libros clasificados por temática.

### Preguntas (Tabla de libros)
#### ¿Cómo harías la persistencia de los libros favoritos?

En la versión actual de la aplicación, se realiza guardadndo la descripción de los libros favoritos en la Sandbox en con NSUserDefaults. A pesar de utiilizar este método, considero que no es el más correcto ya que si se tuviera persistencia con Core Data este proceso sería innecesario y facilitaría mucho la labor de filtrado de los libros favoritos. Básicamente, se ha optado por esta solución porque es la única que se ha estudiado por el momento pero con perspectiva de modificarla en un futuro.

#### ¿Cómo reflejarías el cambio en la propiedad isFavorite?

Principalmente, se podría hacer de dos maneras. La primera, mediante un Delegado en este caso LibraryTableVC debería implementar métodos de un protocolo definido en donde se realice la modificación de esa propiedad. La segunda sería mediante las notificaciones, con esta forma se lanza una notificación cuando esta propiedad se haya modificado, y desde el view controller deseado se añade un observador para dicho tipo de notificación que la recoja y haga lo que sea necesario. En nuestro caso, dado que el delegado tiene herencia simple y las notificaciones si que se lanzan y se pueden añadir tantos observadores sean necesarios, se ha optado por esta segunda opción.

#### ¿Es una aberración tilizar realoadData desde el punto de vista de rendimiento? ¿Hay alternativas? ¿Cuando crees que vale la pena usarlo?

No es una aberración, ya que reloadData solo actualiza las celdas tabla que están visibles en ese moemento; además hay que tener en cuenta que la TableView solo carga un némro concreto de celdas no todas de golpe asi que no le hace falta cargar todo. 
Si que hay alternativas, la propia tableView tiene otros métodos que permiten realizar actualizaciones más concretas de la tabla como son: reloadRowsAtIndexPaths:withRowAnimation o reloadSections:withRowAnimation. Por otro lado siempre puesdes obtener la vista de una celda en concreto modificarla y mostrarla, lo que es un procesa más complejo y en gran parte inecesario. 
Vale la pena usar reloadData cuando hay un cambio significativo en los datos que afecta a la vista que tenemos en nuestra tabla en este caso si se muestra en la tabla si un libro es favorito o no si que se debe usar relaod data pero si no se refleja de ninguna forma (por ejemplo sería la modificación de un autor) no sería necesario.

## Controlador de libros

Este controlador nos permite mostrar una vista co los detalles del libro, además de incluir un botón para mostrar el controlador que nos permitira visualizar el PDF. En los dispositivos iPAD este controlardo comparte pantalla con la tabla mediante un splitViewController mientra que en los dispositivos iPhone aparace mediante una navegación como una pantalla adicional despues de la tabla.

## Controlador de PDF

Este controlador permite visualizar el PDF, aparece en la navegación al pulsar sobre un botón en el BookViewController

#### ¿Como puedo cambiar el pdf si el usuario cambia de libro en la tabla?

Pues al ser una aberración tener delegados encadenados, la mejor opción es la de usar notificaciones al igual que se describió en el caso de los libros favoritos. Por ello, en este controllador se ha añadido un observador para ver si se ha seleccionado otro libro en la tabla y en el caso que se haya hecho cambiar los datos necesarios.

## Extras

#### ¿Qué fncionalidades le añadirías antes de subirla a la App Store?
La primera, sobre todo por experiencia de usuario, sería la de la descarga y la carga de datos que debería hacerse de forma asíncrona y una vez que se haga mostrar los resultados al usuario. Por otro lado, incluiría un buscador de libros, un enlace a la wiki de los autores, funcionalidades para poder modificar temas de visualización (brillo, contraste, incluir si se puede un odo nocturno, etc.). Finalmente también incluiría la posibilidad de añadir libros que te has descargado tu o incluso una pequeña store para descarga de libros.

#### ¿Qué otro nombre que le pondrías?

Al ser un lector dedicado sobre todo a gente del mundo de la informática un buen nombre podría ser Geek Reader.

#### ¿Otras versiones que se te ocurren? ¿Algo que peudas monetizar?

Lo primero incluir una store de libros. Seguidamente al ya tener una plataforma para archivos PDF el siguiente paso podría ser todo tipo de archivos multimedias: ePubs, vídeos, revistas, periodicos, etc.

Nota: estaba desarrollando una funcionalidad extra que es la de que al pulsar sobre una temática en la tabla mostrar un collection view con todos los libros de esa temática, pero no está terminada y la he dejado pendiente de incluirla.
