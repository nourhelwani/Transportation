<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Pages_Default" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div id="mapContainer" style="width: 85%;height: 100%;position:absolute;top:0px;left:0px;">
        </div>
    <form id="form1" runat="server"> 
     <asp:ScriptManager ID="ScriptManager1" runat="server"/>
    <div id="tboxContainer" style="width:15%;height:50%;position:absolute;top:200px;right:0px;">
        <asp:TextBox ID="tboxStartPlace" runat="server"></asp:TextBox> <br /><br /><br /><br />
        <ajax:AutoCompleteExtender ID="AutoCompleteExtenderStart" runat="server" TargetControlID="tboxStartPlace"
            MinimumPrefixLength="2" EnableCaching="true" CompletionSetCount="3" CompletionInterval="1" ServiceMethod="getPlaceName"></ajax:AutoCompleteExtender>
        <asp:TextBox ID="tboxEndPlace" runat="server"></asp:TextBox>
        <ajax:AutoCompleteExtender ID="AutoCompleteExtenderEnd" runat="server" TargetControlID="tboxEndPlace"
            MinimumPrefixLength="2" EnableCaching="true" CompletionSetCount="3" CompletionInterval="1" ServiceMethod="getPlaceName"></ajax:AutoCompleteExtender>
    </div>
        </form>
    <div id="btnContainer" style="width:15%;height:50%;position:absolute;top:70%;right:0px;">
        <asp:Table runat="server" ID="lblAndbtn">
            <asp:TableRow>
                <asp:TableCell>
                    Your Start<br/>Place Is :
                </asp:TableCell>
                <asp:TableCell>
                    <asp:Label ID="lblNameStartPlace" runat="server" style="visibility:hidden" >start</asp:Label>
                </asp:TableCell>
                <asp:TableCell>
                    <button id="btnChangeStartPlace" runat="server" onclick="resetPlace(1)" style="visibility:hidden" >Change</button>
                </asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>
                    Your End<br/>Place Is :
                </asp:TableCell>
                <asp:TableCell>
                    <asp:Label ID="lblNameEndPlace" runat="server" style="visibility:hidden" >end</asp:Label>
                </asp:TableCell>
                <asp:TableCell>
                    <button id="btnChangeEndPlace" runat="server" onclick="resetPlace(2)" style="visibility:hidden" >Change</button>
                </asp:TableCell>
            </asp:TableRow>
        </asp:Table>
        </div>
    <script src="https://maps.googleapis.com/maps/api/js"></script>
    <script>
        var startPlace="";
        var endPlace="";
        var arrayPlacesDrawedOnMap=[];
        //creat array all places we are support it from function 1
        arrayPlacesDrawedOnMap=drawLayerPlacesOnMap();
        //
        function drawLayerPlacesOnMap(){
            var places,placeToDraw,allAreaDrawed,areaDrawing,allLatLngsShape,latLngsOneCorner;
            allAreaDrawed=[];
            //get all places from DB table AREA_CORDINATS
            places =<%= JSONHelper.GetAllPlaces() %>;
            for(var place in places){
                var polyCoords=[];
                placeToDraw=places[place];
                //this array contain string coords of shape this place 
                allLatLngsShape=placeToDraw.COORDS.split('@');
                for (var i = 0; i < allLatLngsShape.length; i++) {
                    //this array contain latlngs one corner of shap
                    latLngsOneCorner=allLatLngsShape[i].split(',');
                    polyCoords.push(new google.maps.LatLng(parseFloat(latLngsOneCorner[0]),parseFloat(latLngsOneCorner[1])));
                }
                //now draw shape
                areaDrawing=  new google.maps.Polygon({
                    paths: polyCoords,
                    strokeOpacity: 0,
                    fillOpacity: 0,
                    areaName: placeToDraw.AREA_NAME,
                    isContain:placeToDraw.IS_CONTAINER,
                });
                //this array contain all shape drawing
                allAreaDrawed.push(areaDrawing);
            }
            return allAreaDrawed;
        }
        function setPlace(point){
            //if start place or end place not choised by user
            if (startPlace==""|| endPlace=="") {
                var placeChoised="";
                for (var i = 0; i < arrayPlacesDrawedOnMap.length; i++) {
                    var place=arrayPlacesDrawedOnMap[i];
                    //if into !
                    if (google.maps.geometry.poly.containsLocation(point,place)) {
                        //اذا هي المنطقة حاوية لمنطقة تانية بيحط اسكها بالمتحول وبكمل بحث
                        //في حال خلص دوران وكانت هالضغطة تنتمي للمنطقة الحاوية(الكبيرة) ولا تنتمي للمنطقة الصغيرة بكون خلص دوران ومعو اسم المنطقة الكبيرة
                        //أما اذا هو وعم يلف وجد أنو الضغطة تنتمي لمنطقة تانية وأكيد هالمنطقة حتكون هي الصغيرة الموجودة داخل الحاوية بياخد اسمها وبخزنو
                        //أما اذا المنطقة مو حاوية فورا بروح عال إيلس وبياخد اسم هالمنطقة وبيكسر الحلقة بعدها
                        if (place.isContain==1){
                            placeChoised=place.areaName;
                            continue;
                        }
                        else{
                            placeChoised= place.areaName;
                            break;
                        }
                    }
                    //if dont contain in all place alert and return function
                    if (i==arrayPlacesDrawedOnMap.length-1 && placeChoised==""){
                        alert("This place isn't supported \n Click again");
                        return;
                    }
                }
                //الكود بيصل لهون في حال وجد أنو الضغطة بتنتمي لأحد مناطقنا وخزن اسمها عندو
                //start place ="" ==> set name place in start place
                if (startPlace=="") {
                    //set name place choised in start place
                    startPlace=placeChoised;
                    //set visibilty to button and lable area name user choise it
                    var controle=document.getElementById('<%=lblNameStartPlace.ClientID%>');
                    controle.textContent=startPlace;
                    controle.style.visibility="visible";
                    document.getElementById('<%=btnChangeStartPlace.ClientID%>').style.visibility="visible";
                    //
                }
                    //mean end place = ""
                else {
                    //set name place choised in end place
                    endPlace=placeChoised;
                    //set visibilty to button and lable area name user choise it
                    var controle= document.getElementById('<%=lblNameEndPlace.ClientID%>');
                    controle.textContent=endPlace;
                    controle.style.visibility="visible";
                    document.getElementById('<%=btnChangeEndPlace.ClientID%>').style.visibility="visible";
                    //
                }
            }
                //mean user chois start place and end place
            else
                alert("You are set start and End places\nTo change any place click buttne");
        }
        ///function to reset place user choise it by click on map
        function resetPlace (trigreControl){
            //to reset start place after click button change in row start place in home page
            if (trigreControl==1) {
                if (startPlace!="") {
                    startPlace="";
                    document.getElementById('<%=lblNameStartPlace.ClientID%>').style.visibility="hidden";
                    document.getElementById('<%=btnChangeStartPlace.ClientID%>').style.visibility="hidden";
                }
            }
            //
            //to reset end place after click button change in row end place in home page
            if (trigreControl==2) {
                if (endPlace!="") {
                    endPlace="";
                    document.getElementById('<%=lblNameEndPlace.ClientID%>').style.visibility="hidden";
                    document.getElementById('<%=btnChangeEndPlace.ClientID%>').style.visibility="hidden";
                }
            }
            //
        }
        ///
        function initialize() {
            var mapContainer = document.getElementById('mapContainer');
            var mapOptions = {
                center: new google.maps.LatLng(33.5074755, 36.2828954),
                zoom: 13,
                minZoom: 13,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            var map = new google.maps.Map(mapContainer, mapOptions);
            google.maps.event.addListener(map, "click", function (e) {
                var latLngAfterClick = e.latLng;
                //call function to set start or end place and send to function coords point 
                setPlace(latLngAfterClick);
            });
        }
        google.maps.event.addDomListener(window, 'load', initialize);
    </script>
</body>
</html>
