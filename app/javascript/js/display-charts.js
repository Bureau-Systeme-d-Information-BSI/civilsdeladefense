import Highcharts from 'highcharts'
import Lightpick from 'lightpick'
import moment from 'moment'

Highcharts.setOptions({
  lang: {
    loading: 'Chargement...',
    months: ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'],
    weekdays: ['dimanche', 'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi'],
    shortMonths: ['jan', 'fév', 'mar', 'avr', 'mai', 'juin', 'juil', 'août', 'sep', 'oct', 'nov', 'déc'],
    exportButtonTitle: "Exporter",
    printButtonTitle: "Imprimer",
    rangeSelectorFrom: "Du",
    rangeSelectorTo: "au",
    rangeSelectorZoom: "Période",
    downloadPNG: 'Télécharger en PNG',
    downloadJPEG: 'Télécharger en JPEG',
    downloadPDF: 'Télécharger en PDF',
    downloadSVG: 'Télécharger en SVG',
    resetZoom: "Réinitialiser le zoom",
    resetZoomTitle: "Réinitialiser le zoom",
    thousandsSep: " ",
    decimalPoint: ','
  }
})

export default function displayCharts() {
  var perDayChartNode = document.getElementById('per-day-graph')
  if (perDayChartNode !== null && perDayData !== undefined) {
    const perDayChart = Highcharts.chart(perDayChartNode, {
      height: '200px',
      chart: {
        styledMode: true
      },
      title: {
        text: null
      },
      credits: {
        enabled: false
      },
      tooltip: {
        crosshairs: true
      },
      legend: {
        enabled: false
      },
      xAxis: {
        type: 'datetime'
      },
      yAxis: {
        allowDecimals: false,
        legend: {
          enable: false
        },
        title: {
          text: null
        }
      },
      series: [{
        type: 'column',
        name: 'Nombre de candidatures',
        data: perDayData.map(function(point) {
          return [
            new Date(point[0]).getTime(),
            point[1]
          ];
        })
      }]
    })
  }

  var date_start_node = document.getElementById('date_start')
  var date_end_node = document.getElementById('date_end')
  if ((date_start_node !== null) && (date_end_node !== null)) {
    new Lightpick({
      field: document.getElementById('date_start'),
      secondField: document.getElementById('date_end'),
      singleDate: false,
      numberOfColumns: 2,
      numberOfMonths: 2,
      maxDate: moment(),
      onClose: function() {
        var start = this._opts.startDate
        var end = this._opts.endDate
        var url = new URL(window.location.href)
        url.searchParams.set('start', start.format('YYYYMMDD'))
        url.searchParams.set('end', end.format('YYYYMMDD'))
        window.location.href = url.href
      }
    })
  }
}
