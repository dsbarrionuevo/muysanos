(function () {
//        blue #2196F3
//        red #F44336
//        light green #8BC34A
//        yellow #FFEB3B
//        orange #FF9800
    var canvas, contexto, torta;
    $(document).ready(function () {
        canvas = $("#graficoAlimentos").get(0);
        contexto = canvas.getContext("2d");
        torta = new GraficoTorta(canvas.width / 2, canvas.height / 2, 200, ["#F44336", "#8BC34A", "#2196F3", "#FFEB3B", "#FF9800"]);
        torta.dibujar(contexto);
        canvas.addEventListener("click", function (evt) {
            var x = evt.offsetX;
            var y = evt.offsetY;
            var color = torta.obtenerColor(x, y);
            
        });
    });

    function GraficoTorta(x, y, radio, colores) {
        this.x = x;
        this.y = y;
        this.radio = radio;
        this.colores = colores;
        this.dibujar = function (contexto) {
            var anguloInicio = 0;
            var anguloFin = 0;
            for (var i = 0; i < this.colores.length; i++) {
                var anguloParcial = (360 / this.colores.length) * (Math.PI / 180);
                anguloFin = anguloInicio + anguloParcial;
                contexto.fillStyle = this.colores[i];
                contexto.beginPath();
                contexto.moveTo(this.x, this.y);
                contexto.lineTo(this.x + Math.cos(anguloInicio) * this.radio, this.y + Math.sin(anguloInicio) * this.radio);
                contexto.lineTo(this.x + Math.cos(anguloFin) * this.radio, this.y + Math.sin(anguloFin) * this.radio);
                contexto.moveTo(this.x, this.y);
                contexto.arc(this.x, this.y, this.radio, anguloInicio, anguloFin);
                contexto.fill();
                anguloInicio = anguloFin;
            }
        };
        this.obtenerColor = function (x, y) {
            if (Math.sqrt((x - this.x) * (x - this.x) + (y - this.y) * (y - this.y)) < this.radio)
            {
                var angulo = Math.atan2((y - this.y), (x - this.x));
                if (angulo < 0) {
                    angulo += 360 * (Math.PI / 180);
                }
                //console.log((angulo * 180/Math.PI));
                var anguloInicio = 0;
                var anguloFin = 0;
                for (var i = 0; i < this.colores.length; i++) {
                    var anguloParcial = (360 / this.colores.length) * (Math.PI / 180);
                    anguloFin = anguloInicio + anguloParcial;
                    if (angulo >= anguloInicio && angulo < anguloFin) {
                        //document.body.style.background = this.colores[i];
                        return this.colores[i];
                    }
                    anguloInicio = anguloFin;
                }
            }
            return null;
        };
    }
})();