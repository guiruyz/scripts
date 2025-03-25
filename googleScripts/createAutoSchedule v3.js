// @ts-nocheck
function createTestbedSchedule() {
  const sheet = SpreadsheetApp.openByUrl("https://docs.google.com/spreadsheets/d/1SewM9TzsFPM8D3zJTgYSZeDKCYur96loRPuQIB27fjY/edit?resourcekey=&gid=374300266#gid=374300266").getSheetByName('Respostas ao formulário 1');
  var data = sheet.getDataRange().getValues();
  const calendarID = "c_8hlpomdmbh08tkgapu93rd2dsc@group.calendar.google.com";
  
  var i = ((data.length) - 1);
  var title = data[i][2];
  var wr = data[i][1];
  var demo = data[i][3];
  var demoDesc = data[i][4];
  var ru = data[i][6];
  var bw = data[i][7];
  var rb = data[i][9];
  var core = data[i][10];
  var ue = data[i][11]
  var date = new Date(data[i][12]);
  var local = data[i][8];
  var confir; 

  //definir o calendario 
  calendar = CalendarApp.getCalendarById(calendarID);

  if (demo == "Sim"){bw = "n78: 3600 - 3700 MHz";}

  var isConflict = false;
  
  // Assegure-se de que os dados são de tipo Date
  var startTime, endTime;
  try {
    startTime = new Date(date.getFullYear(), date.getMonth(), date.getDate(), data[i][13].getHours(), data[i][13].getMinutes());
    endTime = new Date(date.getFullYear(), date.getMonth(), date.getDate(), data[i][14].getHours(), data[i][14].getMinutes());
  } 
  //Notificação de erro
  catch (error) {
    Logger.log("Erro ao converter Hora: " + error);
    sheet.getRange(i + 1, 16).setValue("não registrado");
    GmailApp.sendEmail(wr,"Falha ao registrar - Agenda TestBed", "verifique a disponibilidade na agenda ou tente novamente mais tarde =(")
    return; 
  }

  // Verificação de conflitos 
  for (var b = 1; b < data.length; b++) {

    var bw2 = data[b][7];
    
    var ru2 = data[b][6];

    var rb2 = data[b][9];
    
    var date1 = (data[i][12]);

    var date2 = (data[b][12]);

    var local2 = data[b][8];

    var title2 = data[b][2];

    console.log(b + "x")

    if (date2.getTime() === date1.getTime() && b !==  i && ((data[b][15]) !== "não registrado")) {
      confir = verificarHorarioDisponivel(date2, data[b][13], data[b][14],title2,b,sheet)
      var startTime2 = convertTimeToSeconds(data[b][13]);
      var endTime2 = convertTimeToSeconds(data[b][14]);
      var startTime1 = convertTimeToSeconds(data[i][13]);
      var endTime1 = convertTimeToSeconds(data[i][14]);
      var ue2 = data[b][10];
      if (((((startTime1 < endTime2 && startTime1 > startTime2) || (endTime1 < endTime2 && endTime1 > startTime2) || (startTime1<=startTime2 && endTime1>=endTime2))) && rb !== "Não aplicável" && (confir === false)) ) {
        console.log("\n deu pipico!!" + confir);
        if ((rb === rb2) || (bw2 === bw && local === local2 && bw !== null && bw !== "") || (ru === ru2 && ru !== "" && ru !== null && ru !== "Não aplicável") || (ue === ue2 && ue !== "Não aplicável" && ue !== "") ){
          console.log("\n pipico confirmado xiiiii!!");
          console.log("Conflito em:"+ (b + 1));
          isConflict = true;
        }
        else{isConflict = false;};
      }
    }
  }


  // Caso se for uma demonstração
  console.log("S:"+ startTime1 +" e:" +endTime1);
  if (demo == "Sim"){
    var description = `agendado por: ${wr}\nDesc.: ${demoDesc}`;
    if (isConflict) {
      sheet.getRange(i + 1, 16).setValue("não registrado");
      GmailApp.sendEmail(wr,"Falha ao registrar - Agenda TestBed", "verifique a disponibilidade na agenda ou tente novamente mais tarde =(")
    } 
    else if (data[i][15] !== "registrado" && data[i][15] !== "não registrado") {
      var event = calendar.createEvent(title, startTime, endTime, {description: description});
      event.addGuest(wr);
      sheet.getRange(i + 1, 16).setValue("registrado");
      console.log(b + "sucesso!!")
      //GmailApp.sendEmail(wr,"Confirmação de registro - Agenda TestBed", "Registrado com sucesso na agenda =)")
    }
  }
  // Caso se não for uma demonstração
  else {

    // Registrar na agenda 
    var description = `agendado por: ${wr}\nru: ${ru}\nbw: ${bw} \nradio base: ${rb}\ncore info: ${core} \nTerminal: ${ue}`;
    if (isConflict || startTime1 > endTime1) {
      sheet.getRange(i + 1, 16).setValue("não registrado");
      GmailApp.sendEmail(wr,"Falha ao registrar - Agenda TestBed", "verifique a disponibilidade na agenda ou tente novamente mais tarde =(")
    } 
    else if (data[i][15] !== "registrado" && data[i][15] !== "não registrado") {
      var event = calendar.createEvent(title, startTime, endTime, {description: description, location: local});
      event.addGuest(wr);
      sheet.getRange(i + 1, 16).setValue("registrado");
      if ((endTime1 - startTime1)> 9000) {
        GmailApp.sendEmail(wr,"Atenção!! - Agenda Testbed", "Por favor, evite agendar mais que 2 horas e 30 minutos.")
      }
      console.log(b + "\n sucesso!!")
      //GmailApp.sendEmail(wr,"Confirmação de registro - Agenda TestBed", "Registrado com sucesso na agenda =)");
    }
  }
}
function convertTimeToSeconds(dateStr) {

  var date = new Date(dateStr);

  // Extrai as horas, minutos e segundos
  var hours = date.getHours(); 
  var minutes = date.getMinutes();  
  var seconds = date.getSeconds(); 

  // Converte o horário para segundos
  var totalSeconds = (hours * 3600) + (minutes * 60) + seconds;

  return totalSeconds;
}

function verificarHorarioDisponivel(date, timeStart,timeEnd,title2,b,sheet) {
  const calendarID = "c_8hlpomdmbh08tkgapu93rd2dsc@group.calendar.google.com";
  console.log("\n verificando!!")
  //const partDate = date.split("/");
  //const dateISO = `${partDate[2]}-${partDate[1]}-${partDate[0]}`;

  const calendar = CalendarApp.getCalendarById(calendarID);

  startTimeRe = new Date(date.getFullYear(), date.getMonth(), date.getDate(), timeStart.getHours(), timeStart.getMinutes());
  endTimeRe = new Date(date.getFullYear(), date.getMonth(), date.getDate(), timeEnd.getHours(), timeEnd.getMinutes());
  console.log(startTimeRe);
  console.log(endTimeRe);
  // Obtém eventos no intervalo de tempo especificado
  var events = calendar.getEvents(startTimeRe, endTimeRe);

  var titles = events.map(event => event.getTitle());

  console.log(events);
  console.log(titles);


  console.log(title2)
  var hasSameTitle = events.some(event => event.getTitle() === title2);
  if (hasSameTitle) {
    console.log("\n não tá podendo!!");
    return false;
  } else {
    console.log("\n pode agendar!!");
    sheet.getRange(b + 1, 16).setValue("não registrado");
    return true;
  }
}

