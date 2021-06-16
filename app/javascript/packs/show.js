window.onload = function() {
  
  let slideIndex = 0;
  // let chart;
  let axis_number = 8;
  let axis_width = 1;
  let chart_label = new Array();
  let chart_ac = new Array();
  let chart_pv = new Array();
  let chart_ev = new Array();
  let velocity = new Array();
  let chart_expense = new Array();
  let ac = 0;
  let pv = 0;
  let ev = 0;
  let this_week_velocity = 0;
  let expense = 0;
  let change_axis = 0;
  let i = 0;
  let slideLimit = 7;
  let carender_index = 0;
  let active_days = gon.active_days
  let month_number_for_all = Math.ceil(active_days/7) + 2
  let current_week = gon.week_beginning;
  let current_month = gon.month_beginning;
  let period_index = 0;
  changeSlide();
  showChart(1);
  showChart(0);
  $('.unconfirmed').parent().parent().parent().css('opacity',0.25);
  $('.qc_checked').click(function(){
    if ($(this).hasClass('unconfirmed')) {
      $(this).parent().parent().parent().css('opacity',0.25);
    }
  })
  function changeSlide(){
    $('.direction').show();
    $('#date').show();
    if (slideIndex == 0){
      $('.prev-btn').hide();
    } 
    if (slideIndex == Math.ceil(active_days/slideLimit)){
      $('.next-btn').hide();
    }
    if (period_index == 3){
      $('.direction').hide();
      $('#date').hide();
    }
  }


  
  function newChart_for_money(){
    let day;
    i = 0;
    chart_label = [];
    chart_expense = [];
    for (let n = 0; n < axis_number; n++){
      day = getAfterNdays(i, carender_index);
      i += axis_width;
      for (let key in gon.daily_cost){
        if (key < day){
          expense += gon.daily_cost[key]
        }
      }
      chart_label.push(day);
      chart_expense.push(expense);
      day = [];
      expense = 0;
    }
    const date = document.getElementById("date");
    date.textContent = currentDate();
    const chartData = {
      labels: chart_label,
      datasets: [
        {
          label: '赤字ライン',
          type: 'line',
          data: [gon.cost,gon.cost,gon.cost,gon.cost,gon.cost,gon.cost,gon.cost,gon.cost,gon.cost,gon.cost],
          borderColor: "rgba(255,0,0,1)",
          lineTension: 0,
          backgroundColor: "rgba(0,0,0,0)"
        },
        {
          label: '人件費',
          type: 'line',
          data: chart_expense,
          borderColor: "rgba(0,0,255,1)",
          lineTension: 0,
          backgroundColor: "rgba(0,0,0,0)"
        },
        {
          label: '目標ライン',
          type: 'line',
          data: [gon.planned_cost,gon.planned_cost,gon.planned_cost,gon.planned_cost,gon.planned_cost,gon.planned_cost,gon.planned_cost,gon.planned_cost,gon.planned_cost,gon.planned_cost],
          borderColor: "rgba(255,255,0,1)",
          lineTension: 0,
          backgroundColor: "rgba(0,0,0,0)"
        }
      ],
    }
    return chartData;
  }

  function newChart_for_time(){
    let day;
    let last_ev = 0;
    i = 0;
    chart_label = [];
    chart_ac = [];
    chart_pv = [];
    chart_ev = [];
    velocity = [];
    this_week_velocity = 0
    for (let n = 0; n < axis_number; n++){
      day = getAfterNdays(i, carender_index);
      i += axis_width;
      for (let key in gon.daily_ac){
        if (key < day){
          ac += gon.daily_ac[key]
        }
      }
      for (let key in gon.daily_pv){
        if (key < day){
          pv += gon.daily_pv[key]
        }
      } 
      for (let key in gon.daily_ev){
        if (key < day){
          ev += gon.daily_ev[key]
        }
      }
      this_week_velocity = ev - last_ev
      velocity.push(this_week_velocity);
      chart_label.push(day);
      chart_ac.push(ac);
      chart_pv.push(pv);
      chart_ev.push(ev);
      last_ev = ev

      day = [];
      ac = 0;
      pv = 0;
      ev = 0;
    }
    const date = document.getElementById("date");
    date.textContent = currentDate();
    
    const chartData = {
      labels: chart_label,
      datasets: [
        {
          label: 'EV累計',
          type: 'line',
          data: chart_ev,
          borderColor: "rgba(255,0,0,1)",
          lineTension: 0,
          backgroundColor: "rgba(0,0,0,0)",
          yAxisID: 'left-y-axis'
        },
        {
          label: 'PV累計',
          type: 'line',
          data: chart_pv,
          borderColor: "rgba(0,0,255,1)",
          lineTension: 0,
          backgroundColor: "rgba(0,0,0,0)",
          yAxisID: 'left-y-axis'
        },
        {
          label: 'AC累計',
          type: 'line',
          data: chart_ac,
          borderColor: "rgba(255,255,0,1)",
          lineTension: 0,
          backgroundColor: "rgba(0,0,0,0)",
          yAxisID: 'left-y-axis'
        },
        {
          label: 'Velocity',
          type: 'line',
          data: velocity,
          borderColor: "rgba(0,0,128,0.5)",
          lineTension: 0,
          backgroundColor: "rgba(0,0,128,0.5)",
          yAxisID: 'right-y-axis'
        }
      ],
    }
    return chartData;
  }

  function showChart(x){
    let chart;
    let labelString;
    let chartData = []
    let ctx;
    let time_yAxes = [
      {
        id: 'left-y-axis',
        position: 'left',
        gridLines: {
          drawTicks: true
        },
        ticks: {
          suggestedMin: 0,
          callback: function(value, index, values){
            return  value + labelString
          }
        }
      },
      {
        id: 'right-y-axis',
        position: 'right',
        gridLines: {
          drawOnChartArea: false
        },
        ticks: {
          suggestedMin: 0,
          callback: function(value, index, values){
            return  value + labelString
          }
        }
      }
    ]
    let money_yAxes = [
      {
        id: 'left-y-axis',
        position: 'left',
        gridLines: {
          drawTicks: true
        },
        ticks: {
          suggestedMin: 0,
          callback: function(value, index, values){
            return  value + labelString
          }
        }
      }
    ]
    
    
    chart = []
    if (x == 0){
      chartData = newChart_for_time()
      ctx = document.getElementById("time"); 
      labelString = "時間"
      yAxes = time_yAxes
      // options = timeChart_yAxes
    } else if (x == 1) {
      chartData = newChart_for_money()
      ctx = document.getElementById("money"); 
      labelString = "万円"
      yAxes = money_yAxes
      // options = moneyChart_yAxes
    }

    chart = new Chart(ctx, {
        type: 'line',
        data: chartData,
        options: {
          scales: {
            yAxes: yAxes
          }
        }
    });
  }
  

  function getAfterNdays(axis_width, carender_index){
    // 1週間
    let dt = [];
    let week_skip;
    let two_week_skip;
    let month_skip;
    if (period_index == 0) {
      week_skip = carender_index * 7
      dt = new Date(current_week);
      dt.setDate(dt.getDate()+axis_width+week_skip);
    }
    // 2週間
    if (period_index == 1){
      two_week_skip = carender_index * 14
      dt = new Date(current_week);
      dt.setDate(dt.getDate()+axis_width+two_week_skip);
    }
    // 1ヶ月
    if (period_index == 2) {
      month_skip = carender_index
      dt = new Date(current_month);
      dt.setMonth(dt.getMonth()+month_skip);
      dt.setDate(dt.getDate()+axis_width);
    }
    // 全期間
    if (period_index == 3){
      dt = new Date(current_month);
      dt.setDate(dt.getDate()+axis_width);
    }
    return formatDate(dt);
  }

  function formatDate(dt) {
    let y = dt.getFullYear();
    let m = ('00' + (dt.getMonth()+1)).slice(-2);
    let d = ('00' + dt.getDate()).slice(-2);
    return (y + '-' + m + '-' + d);
  }
  function currentDate(){
    let dts = new Date(chart_label[0]);
    let ys = dts.getFullYear();
    let ms = ('00' + (dts.getMonth()+1)).slice(-2);
    return (ys + '年' + ms + '月');
  }
  
  $('.axis').click(function(){
    if ($(this).hasClass('time')){
      $(this).addClass('decorate')
      $('.money').removeClass('decorate')
      change_axis = 0;
    } else {
      $(this).addClass('decorate')
      $('.time').removeClass('decorate')
      change_axis = 1;
    }
    // if(chart){
    //   chart.destroy();
    // }
    showChart(0);
    showChart(1);
  })

  $('.direction').click(function(){
    if ($(this).hasClass('next-btn')){
      carender_index += 1;
      slideIndex += 1;
    } else {
      carender_index -= 1;
      slideIndex -= 1;
    }
    changeSlide();
    // if(chart){
    //   chart.destroy();
    // }
    showChart(0);
    showChart(1);
  })
  $('.season').click(function(){
    $('.season').removeClass('decorate');
    period_index = $('.season').index(this);
    if(period_index == 0){
      axis_number = 8;
      axis_width = 1;
      slideLimit = 7;
      $(this).addClass('decorate');
    } else if(period_index == 1){
      axis_number = 8;
      axis_width = 2;
      slideLimit = 14;
      $(this).addClass('decorate');
    } else if(period_index == 2){
      axis_number = 9;
      axis_width = 4;
      slideLimit = 30;
      $(this).addClass('decorate');
    } else {
      axis_number = month_number_for_all;
      axis_width = 7;
      $(this).addClass('decorate');
    }
    
    // if(chart){
    //   chart.destroy();
    // }
    slideIndex = 0;
    carender_index = 0;
    changeSlide();
    showChart(0);
    showChart(1);
  })
  
};





