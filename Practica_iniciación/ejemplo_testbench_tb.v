// Testbench ejemplo

`timescale 1 ns / 10 ps //Directiva que fija la unidad de tiempo de simulación y el paso de simulación

module mimodulo_tb; //Declaracion de modulo del testbench


//declaracion de señales

reg test_a, test_b; //las señales de entrada al modulo a testear mimodulo. Se han declarado reg porque queremos inicializarlas
wire test_1, test_2; //señales de salida, se declaran como wire porque sus valores se fijan por el modulo a testear

//instancia del modulo a testear
mimodulo nombre_instancia_mimodulo(test_1, test_2, test_a, test_b);

initial
begin
  $monitor("tiempo=%0d a=%b b=%b test1=%b test2=%b", $time, test_a, test_b, test_1, test_2);
  $dumpfile("mimodulo_tb.vcd");
  $dumpvars;

  //vector de test 0
  test_a = 1'b0;
  test_b = 1'b0;
  #20;

  //vector de test 1
  test_a = 1'b0;
  test_b = 1'b1;
  #20;

  //vector de test 2
  test_a = 1'b1;
  test_b = 1'b0;
  #20;
  //vector de test 3
  test_a = 1'b1;
  test_b = 1'b1;
  #20;
  
  $finish;  //fin simulacion

end
endmodule
