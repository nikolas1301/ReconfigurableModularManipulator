// Programa : Driver motor de passo A4988
// Autor : Arduino e Cia

#include <AccelStepper.h>
#include <MultiStepper.h>
#define pi 3.1416

int velocidade_motor = 0;
int aceleracao_motor = 0;
int sentido_horario = 0;
int sentido_antihorario = 0;
int numero = 0;
int vel_motor = 3 * pi;
int acel_motor = pi;
long pos1[] = {0, 0, 0};
long pos2[] = {0, 0, 0};
long pos3[] = {0, 0, 0};
//long pos1 = 0;
//long pos2 = 0;
//long pos3 = 0;
long poses[27] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
long poses1[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
long poses2[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
long poses3[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
long graus[] = {pos1, pos2, pos3};
long inicio[] = {0, 0, 0};
int i = 0, count, j = 0, h = 0, k = 0, f = 0, g = 0;

// Definicao pino ENABLE
int pino_enable = 10;
int pino_enable2 = 11;
int pino_enable3 = 5;

// Definicao pinos STEP e DIR
AccelStepper motor1(1, 12, 8 );
AccelStepper motor2(1, 9, 6 );
AccelStepper motor3(1, 7, 4 );

MultiStepper motores;

void setup()
{
  motor1.setMaxSpeed(500);
  motor2.setMaxSpeed(500);
  motor3.setMaxSpeed(500);

  motores.addStepper(motor1);
  motores.addStepper(motor2);
  motores.addStepper(motor3);

  Serial.begin(115200);
}

void loop()
{

  if (Serial.available() > 0) {
    count = 0;
    while (count < 27) {
      if (Serial.available() > 0) {
        poses[count] = Serial.read();
        count++;
      }
    }

    for (h; h < 27; h++) {
      poses[h] = poses[h] - 48;
    }

    for (j; j < 3; j++) {
      pos1[0] = (poses[j] * pow(10, 2 - j)) + pos1[0];
      pos1[1] = (poses[j + 3] * pow(10, 2 - j)) + pos1[1];
      pos1[2] = (poses[j + 6] * pow(10, 2 - j)) + pos1[2];

      pos2[0] = (poses[j + 9] * pow(10, 2 - j)) + pos2[0];
      pos2[1] = (poses[j + 12] * pow(10, 2 - j)) + pos2[1];
      pos2[2] = (poses[j + 15] * pow(10, 2 - j)) + pos2[2];

      pos3[0] = (poses[j + 18] * pow(10, 2 - j)) + pos3[0];
      pos3[1] = (poses[j + 21] * pow(10, 2 - j)) + pos3[1];
      pos3[2] = (poses[j + 24] * pow(10, 2 - j)) + pos3[2];
    }

  }

  for (g; g < 3; g++) {
    if (pos1[g] > 200) {
      pos1[g] = pos1[g] - 360;
    }
    if (pos2[g] > 220) {
      pos2[g] = pos2[g] - 360;
    }
    if (pos3[g] > 220) {
      pos3[g] = pos3[g] - 360;
    }
  }

  for (f; f < 3; f++) {
    pos1[f] = (pos1[f] * 16) / 1.8;
    pos2[f] = (pos2[f] * 16) / 1.8;
    pos3[f] = (pos3[f] * 16) / 1.8;
  }

  long graus[] = {pos1, pos2, pos3};

  //for (i=0; i < 3; i++) {
    motores.moveTo(graus[0]);
    motores.runSpeedToPosition();
    delay(1500);

    motores.moveTo(graus[1]);
    motores.runSpeedToPosition();
    delay(1500);

    motores.moveTo(graus[2]);
    motores.runSpeedToPosition();
    delay(1500);

//    motores.moveTo(inicio);
//    motores.runSpeedToPosition();
//    delay(4000);

  //}

}
