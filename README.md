# Solitario de Pirámide

Este proyecto es una implementación en Smalltalk del clásico juego de cartas "Solitario de Pirámide", desarrollado como trabajo integrador para la asignatura Paradigmas de Programación (Universidad Tecnológica Nacional).

## Característica propia (Innovación)
**Sistema de Power-Ups mediante cartas y combinaciones especiales**
Como variante original del juego, hemos introducido un sistema de mecánicas con efectos especiales (Power-Ups) que alteran el transcurso de la partida:
* **Efectos del Rey (K):** Al eliminar un Rey (que normalmente vale 13 por sí solo), se activará un efecto especial aleatorio. Esto puede resultar en una ventaja (como sumar puntos extra o añadir tiempo al cronómetro) o en una penalización (restar puntos o disminuir el tiempo).
* **Combinación 6 + 7:** Al lograr esta combinación específica para sumar 13, también se desencadenarán efectos especiales similares a los de la carta K, premiando al jugador por realizar esta unión exacta.

## Integrantes del Grupo

| Integrante | 
| :--- | :--- | :--- |
| Cabral, Lautaro |
| Gonzales, Luis | 
| Carballo Ucero, Bautista |
| Pedrozo Rios, Tiago Federico | 
| De Bortoli, Lautaro Agustín | 



## Requisitos Técnicos
* **Entorno:** Pharo 13.0 (versión de 64 bits recomendada).
* **Dependencias:** El proyecto es completamente autocontenido. No requiere conexión a internet para su ejecución ni la instalación de paquetes externos adicionales.

## Instalación
1. Clonar este repositorio en tu máquina local.
2. Abrir **Pharo 13.0**.
3. Abrir la herramienta **Iceberg** (desde el World Menu o atajo rápido).
4. Hacer clic en **Add** y seleccionar **Import from existing clone**.
5. Seleccionar el directorio raíz donde se clonó el repositorio.
6. Una vez agregado a Iceberg, hacer clic derecho sobre el proyecto, seleccionar **Packages**, luego elegir el paquete `SolitarioPiramide` y hacer clic en **Load**.

## Reglas implementadas
* **Disposición:** La pirámide se arma en filas superpuestas. Una carta se considera **libre** si no está cubierta por ninguna carta de la fila inferior.
* **Eliminación clásica:** Se eliminan parejas de cartas libres cuya suma sea exactamente **13**. El Rey (K) vale 13 y se elimina de forma individual.
* **Mazo auxiliar:** Permite descubrir nuevas cartas cuando el jugador no encuentra combinaciones viables en la pirámide.
* **Condiciones de victoria/derrota:** El juego lleva el registro del puntaje obtenido y cuenta con un límite de tiempo (cronómetro) que añade presión al jugador. Se registra además la **mejor puntuación**.
* **Power-Ups (Mecánica propia):** Modificación del puntaje y el tiempo al eliminar Reyes (K) o realizar la combinación de 6 + 7.

*Aun queda por implementar las clases graficas, así como la clase partida que combina toda la lógica para el juego. 
