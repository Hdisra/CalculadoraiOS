//
//  HomeViewController.swift
//  iOS-Calculator
//
//  Created by Israel Hernandez on 08/07/20.
//  Copyright © 2020 Israel Hernandez. All rights reserved.
//

import UIKit

//final para que no se extienda la clase
final class HomeViewController: UIViewController {

    //MARK: --Outlets
    
    //Resultado
    @IBOutlet weak var resultNumber: UILabel!
    
    //Numeros
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numeroDecimal: UIButton!
    
    //Operadores
    @IBOutlet weak var division: UIButton!
    @IBOutlet weak var multiplicar: UIButton!
    @IBOutlet weak var restar: UIButton!
    @IBOutlet weak var sumar: UIButton!
    @IBOutlet weak var igual: UIButton!
    @IBOutlet weak var porcentaje: UIButton!
    @IBOutlet weak var operatorSumaResta: UIButton!
    @IBOutlet weak var operatorAC: UIButton!
    
    //MARK: --Variables
    
    //de tipo privadas para que no podamos acceder a ellas desde otras clases
    private var total: Double = 0 //almacenará el resultado
    private var tempValue: Double = 0 //sera el valor temporal que ira apareciendo en la calculadora
    private var operador = false //nos indicara si realizamos una operacion(al seleccionar un operador)
    private var  decimal = false //servira para saber si seleccionamos el boton para usar numeros decimales
    private var  operation: tipoDeOperacion = .ninguno // indicar la operacion actual
    
    //MARK: Constantes
    //normalmente las constantes en swift se nombran con una k al principio
    //servira para ver como sera el separador de decimas dependiendo de la localidad, ya sea coma, o punto.
    private let kDecimalOpertor = Locale.current.decimalSeparator
    //para el tamaño maximo que se admitira para un numero
    private let kMaxTam = 9 //9 digitos
    //para poner cuales son los valores maximos y minimos que aceptara la calculadora
    // los quitamos ya que queremos contar los numeros para hacer la notacion cientifica: private let kMaxValue: Double = 999999999
    //private let kMinValue = 0.00000001
    //servira para guardar el valor cuando se muera la app
    private let kTotal = "total"
    
    //se encaragara de definir los tipos de operaciones que soporta la calculadora
    private enum tipoDeOperacion {
        
        case ninguno, suma, resta, multiplicacion, dividir, percent
        //en ninguno es por si no se ha seleccionado un operador o si se ha borrado algo
        
    }
    
    //MARK: Formateadores
    
    //Formateo de valores auxiliar
    private let auxFormatter: NumberFormatter = {
        
        //primero definimos el formateador
        let formatter = NumberFormatter()
        //obtenemos cual es el locale(localidad)
        let locale = Locale.current
        //Separador de grupo(groupingSeparator) es cómo se van agrupando cada tres digitos el separador de mil, diez mil, cien mil, el separador de un millón. Y ponemos que ese separados sea vacío, que no se muestre
        formatter.groupingSeparator = ""
        //usamos el locale para asi poderle asignarle el separador decimal (dependiendo en donde se encuentre el usuario , o .)
        formatter.decimalSeparator = locale.decimalSeparator
        //le decimos al formateador que el estilo del numero sea decimal, osea que acepte numeros decimales, no solo enteros
        formatter.numberStyle = .decimal
        //añadimos el numero maximo de numeros enteros
        formatter.maximumIntegerDigits = 100
        //minimo de numeros en forma de fraccion
        formatter.minimumFractionDigits = 0
        //maximo de numeros en forma d fraccion
        formatter.maximumFractionDigits = 100
        
        return formatter
        
    }()
    
    //Formateo de valores auxiliares totales
    private let auxTotalFormatter: NumberFormatter = {
        
        //primero definimos el formateador
        let formatter = NumberFormatter()
        //obtenemos cual es el locale(localidad)
        formatter.groupingSeparator = ""
        //usamos el locale para asi poderle asignarle el separador decimal (dependiendo en donde se encuentre el usuario , o .)
        formatter.decimalSeparator = ""// para que solo cuente el numero de digitos
        formatter.numberStyle = .decimal
        //añadimos el numero maximo de numeros enteros
        
        //hacemos esto para que el formateador sea capaz de representar numeros de una cadena grande, para asi poder contar el numero de digitos sin que se reduzcan con  notacion cientifica
        formatter.maximumIntegerDigits = 100
        //minimo de numeros en forma de fraccion
        formatter.minimumFractionDigits = 0
        //maximo de numeros en forma d fraccion
        formatter.maximumFractionDigits = 100
        
        
        return formatter
        
    }()
    
    //Formateo de valores por pantalla por defecto - va a modificar visualmente el numero para mostrarlo en pantalla
    private let printFormatter: NumberFormatter = {
        
        let formatter = NumberFormatter()
        let locale = Locale.current
        //en este si usamos el separador de grupo de nuestro locale
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        //le decimos a este formateador que como numero entrero va a tener como maximo el 9, que es el numero de dígitos que iba a soportar la calculadora
        formatter.maximumIntegerDigits = 9
        //aqui le decimos que como fraccion o numeros decimales como minimo podemos tener 0, osea que podemos no tener numeros decimales 2.0
        formatter.minimumFractionDigits = 0
        //y aqui como maximo de decimales 8 0.00000000, lo que corresponde con el valor minimo que le pusimos a la calculadora
         formatter.maximumFractionDigits = 8
        return formatter
        
        
    }()
    
    //Formateo para valores exponenciales
    private let printScientificFormatter: NumberFormatter = {
        
        let formatter = NumberFormatter()
        //ponemos que en vez que sea el estilo de numero decima, que sea cientifico
        formatter.numberStyle = .scientific
        //el maximo numero de valores cientificos o exponenciale sera tres
        formatter.maximumFractionDigits = 3
        //y se representara con el simbolo e
        formatter.exponentSymbol = "e"
        return formatter
        
    }()
    
    
    
    //MARK: Inicialización
    //Aqui indicaremos como queremos que se instancie este controlador de vista:
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    //bloque necesario para que se inicialice
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Ciclo de Vida
    override func viewDidLoad() {
        super.viewDidLoad()

        //aqui se cambiara o no el simbolo de decimas (punto o coma) dependiendo de la localidad
        numeroDecimal.setTitle(kDecimalOpertor, for: .normal)
                            //en el titulo que le pondremos dependera de la localizacion y eso se va a evaluar con la constante de kDecimalOperator
        
        //para poner el ultimo valor agregado en la app
        total = UserDefaults.standard.double(forKey: kTotal)
        
        //llamamos a resultado() para que asi se muestre en pantalla el resultado
        resultado()
    }
    
    //para que en un ipad aparezca ya redondo los botones
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        // extensiones que hicimos en el UIButtonExtensions para poder usarlas aqui
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        numeroDecimal.round()
        
        sumar.round()
        restar.round()
        division.round()
        multiplicar.round()
        operatorSumaResta.round()
        igual.round()
        porcentaje.round()
        operatorSumaResta.round()
        operatorAC.round()
        
    }

    
    //MARK: --Acciones de los botones
    
    @IBAction func operatorACAction(_ sender: UIButton) {
        
        //llamamos a la funcion borrar ya que este boton eso es lo que hace
        clear()
        
        
        //Le aplicamos la funcion que hicimos para que brille al tocar cada botón y siempre la dejamos al final para que primero se ejecute la logica y luego que brille
        sender.brillar()
    }
    
    //con este boton cambiara de signo el numero en la calculadora de mas a menos o viceversa: 5 -> -5  o  -5 -> +5
    @IBAction func operatorMasMenosAction(_ sender: UIButton) {
        
        //llamamos a la variable que esta en pantalla
        tempValue = tempValue * (-1) //para que se cambie el signo
        
        //ahora lo mostramos en pantalla a travez del formateador
        resultNumber.text = printFormatter.string(from: NSNumber(value: tempValue))
        
        sender.brillar()
    }
    
    @IBAction func operatorPorcentajeAction(_ sender: UIButton) {
        
        //Si hay una operacion antes, y se oprime este boton, primero hay que finalizar la operacion y despues sacar su porcentaje:
        if operation != .percent {
            resultado() //primero se ejecuta la operacion anterior y ya despues del if se calcula su porcentaje
        }
        
        //primero decimos que si estamos ocupando un operdor
        operador = true
        //decimos de que tipo de operacion será, osea de porcentaje
        operation = .percent
        //llamamos a la funcion resultado(), donde realiza ahi todas las operaciones y ahi llamamos a la operacion porcentaje
        resultado()
        
        
        sender.brillar()
        
    }
    
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        
        if operation != .ninguno {
            
            //llamamos a la funcion de resultado() para que se muestre el resultado de la operacion si es que hay una antes
            resultado()
        }
        operador = true
        operation = .dividir
        sender.selectOperation(true)
        
        
        sender.brillar()
    }
    
    @IBAction func operatorMultiplicarAction(_ sender: UIButton) {
        
        if operation != .ninguno {
            
            //llamamos a la funcion de resultado() para que se muestre el resultado de la operacion si es que hay una antes
            resultado()
        }
        operador = true
        operation = .multiplicacion
        sender.selectOperation(true)
        
        
        sender.brillar()
    }
    
    @IBAction func operatorRestarAction(_ sender: UIButton) {
        
        //llamamos a la funcion resultado para que antes de ejecutar la operacion se muestre el resultado actual antes de restarlo
        resultado()
        operador = true
        operation = .resta
        
        sender.selectOperation(true)
        
        sender.brillar()
    }
    
    //+
    @IBAction func operatorSumarAction(_ sender: UIButton) {
        
        if operation != .ninguno {
            
            //llamamos a la funcion de resultado() para que se muestre el resultado de la operacion si es que hay una antes
            resultado()
        }
        
        //despues decimos que operacion se ejecuta (+)
        operador = true
        operation = .suma
        //accedemos a la operacion con el sender y seleccionamos true a la funcion que le cambia de color
        sender.selectOperation(true)
        sender.brillar()
    }
    
    //=
    @IBAction func operatorIgualAction(_ sender: UIButton) {
        
        //solo llamamos a resulatod() para que imprima el resultado en pantalla
        resultado()
        
        sender.brillar()
    }
    
    
    @IBAction func numeroDecimalAction(_ sender: UIButton) {
        
        //primero obtenemos el valor que esta en pantalla con una constante asociada al formateador auxiliar que creamos
        let ValortempActual = auxTotalFormatter.string(from: NSNumber(value: tempValue))!
        //preguntamos si estamos realizando una operacion con !variable, contamos los numeros que tiene el valor actual y vemos si es mayor o igual al numero de digitos maximo que soporta la calculadora
        if !operador && ValortempActual.count >= kMaxTam{
            
            return // y ahi se regresa y no se hace nada, ya que no podemos sacar numeros decimales a un numero que tiene mas cifras que las que soporta la calculadora
        }
        
        //y si si es menor
        resultNumber.text = resultNumber.text! + kDecimalOpertor! // LE AGREGAMOS DESPUES DEL NUMERO EL PUNTO DECIMAL
        // y ponemos que estamos usando la operacion decimal
        decimal = true
        
        //llamamos a esta funcion para que se cambien de color los operadores
        selectedOperation()
        sender.brillar()
    }
    
    //como ya sabemos que es un boton lo podemos cambiar a UIButton
    @IBAction func numberAction(_ sender: UIButton) {
        
        //al tocar cualquier numero el boton de AC pasara a C
        operatorAC.setTitle("C", for: .normal)
        
        //accedemos al valor formateado de nuestro temporalValue
        var ValortempActual = auxTotalFormatter.string(from: NSNumber(value: tempValue))!
        //hacemos la misma pregunta como en los decimales que si hay una operacion que se esta usando y si no está dentro de los parametros de que tanta cifra tiene el numero entonces no se hara esto
        if !operador && ValortempActual.count >= kMaxTam {
            
            return
        }
        
        //ahora aqui usamos el formateo normal, para que tome en cuenta los decimales:
        ValortempActual = auxFormatter.string(from: NSNumber(value: tempValue))!
        
        //para saber si hemos seleccionado una operacion preguntamos si operador es true
        if operador {
            
            //al pulsar otro numero cuanto estaba pulsado una operacion entonces se almacenara en total el valor temporal
            total = total == 0 ? tempValue : total
            //preguntamos si total es igual a 0 entonces el total será el temporal, y sino (:) será el total. todo eso para limpiar resultados sin perderlos
            
            //y ponemos que el texto de la label y el ValorTempActual será nada
            resultNumber.text = ""
            ValortempActual = ""
            //y al final ponemos que ya acabos de limpiar y guardar los datos
            operador = false
        }
        
        //para saber si seleccionado valores decimales, hacemos lo mismo que con los enteros, nos preguntamos si decimal es true
        if decimal {
            
            //al valor decimal le agregamos el punto decimal
            ValortempActual = "\(ValortempActual)\(String(describing: kDecimalOpertor))"
            
            
            //despues al hacer eso saldremos del if poniendo el decimal en falso
            decimal = false
            
        }
        
        //creamos una constante que guarde el valor del numero que pulse el usuario usando su tag
        let numero = sender.tag
        
        //despues al valor que se muestre en pantalla(tempValue) le damos el valor de ValortempActual mas el numero que pulsamos(numero)
        tempValue = Double(ValortempActual + String(numero))! //ya que no será nulo
    
        //ahora lo mostraremos por pantalla usando el formateador de pantalla
        resultNumber.text = printFormatter.string(from: NSNumber(value: tempValue))
        
        selectedOperation()
        
        //print(sender.tag) //para imprimir el tag que le dimos a cada boton de acuerdo con su numero
        sender.brillar()
    }
    
    //Funcion para limpiar los valores de la calculadora - private
    func clear () {
        
        //accedemos a la constante que mostraba los numeros actuales en la calculadora
        operation = .ninguno
        //le regresamos el nombre a AC
        operatorAC.setTitle("AC", for: .normal)
        //borraremos el resultado total y temporal
        //primero revisamos si hay valores temporales
        if tempValue != 0 {
            //la pondremos a 0 si hay valores
            tempValue = 0
            //y cambiamos el nombre del label del resultado a 0
            resultNumber.text = "0"
        }else {
            
            //y si es 0 el valor temporal entonces al valor total le daremos el valor de 0 tambien
            total = 0
            //y llamamos a la funcion resultado para que calcule lo que este pendiente
            resultado()
        }
        
    }
    
    //funcion que se encargar de obtener el resultado final
    private func resultado() {
        
        //comprobamos primero que operacion ha elegido el usuario y para eso usamos un switch para que sea mas fácil eligir cada caso
        //usamos la constante operation que la hemos asociado con el enum de tipoDeOperacion
        switch operation {

        case .ninguno:
            //si es ninguno no hacemos nada, ya que aqui no hay ninguna operacion
            break// para detener el switch al ser seleccionada una opción
        case .suma:
            //en la suma tenemos que sumarle al valor de total,  el valor de tempValue(el valor que está en la pantalla)
            total = total + tempValue
            break
        case .resta:
            //para la resta es lo mismo
            total = total - tempValue
            break
        case .multiplicacion:
            total = total * tempValue
            break
        case .dividir:
            total = total / tempValue
            break
        case .percent:
            //sirve para sacar el prorcentaje del numero que esta en pantalla(tempValue)
            tempValue = tempValue / 100
            //y el total pasara a ser ese valor
            total = tempValue
            break
        }
        
        //Formatear y mostrar en pantalla
        
        //como ya no hay valores maximos y minimos comprobamos que el numero total no pase de la longitud maxima usando el formateador auxTotalFormatter. //Convertimos a string el valor total
        if let ValortempActual = auxTotalFormatter.string(from: NSNumber(value: total)), ValortempActual.count > kMaxTam {
            
            //Y SI ESE VALOR ACTUAL ES MAYOR A LA LONGITUD DE LAS CIFRAS QUE LE DIMOS ENTONCES LO PASAREMOS A ESCRIBIRLO DE FORMA CIENTIFICA, USANDO EL FORMATEADOR DE NUMEROS EXPONENCIALES printScientificFormatter
            resultNumber.text = printScientificFormatter.string(from: NSNumber(value:  total))
            
        }else {
            
            //en caso contrario que el numero no tenga tants cifras usaremos el formateador normal
            //y el total lo mostramos en pantalla accediendo al formateador que creamos para mostrar en pantalla el total con las especificaciones ya puestas en el formateador
            resultNumber.text = printFormatter.string(from: NSNumber(value: total)) //pero tenemos que convertir la variable de tipo NSNumber
            
            
        }
        
        //despues de hacer una operacion se tiene que poner .ninguno
        operation = .ninguno
        
        selectedOperation()//para que deje de estar seleccionada la opcion
        
        //para hacer guardado de datos simples:
        UserDefaults.standard.set(total, forKey: kTotal) //guardamos el valor de total usando la constante que definimos
        
        print("TOTAL: \(total)")
        
        
    }
    
    //creamos una funcion para que al seleccionar un boton ese se quede visualmente seleccionado
    private func selectedOperation() {
        
         //comprobamos primero si si estamos operando
        if !operador {
            
            //no esta operando
            //diremos que no se cambiara de color con la extension creada a cada boton de operador
            sumar.selectOperation(false)
            restar.selectOperation(false)
            multiplicar.selectOperation(false)
            division.selectOperation(false)
            
        }else {
            //comprbamos que operacion se esta utilizando
            switch operation {
            
            //estos dos seran un case ya que si no estamos operando o se selecciona el boton de porcentaje, originalmente no se queda maracado al seleccionarlo
            case .ninguno, .percent:
                //en este caso todos seran falso
                sumar.selectOperation(false)
                restar.selectOperation(false)
                multiplicar.selectOperation(false)
                division.selectOperation(false)
                break
            case .suma:
                //aqui solo seria la suma
                sumar.selectOperation(true)
                restar.selectOperation(false)
                multiplicar.selectOperation(false)
                division.selectOperation(false)
                break
            case .resta:
                
                sumar.selectOperation(false)
                restar.selectOperation(true)
                multiplicar.selectOperation(false)
                division.selectOperation(false)
                break
            case .multiplicacion:
                
                sumar.selectOperation(false)
                restar.selectOperation(false)
                multiplicar.selectOperation(true)
                division.selectOperation(false)
                break
            case .dividir:
                
                sumar.selectOperation(false)
                restar.selectOperation(false)
                multiplicar.selectOperation(false)
                division.selectOperation(true)
                break
                            
            }
        }
    }
    
    
}
