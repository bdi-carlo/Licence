byCar(auckland,hamilton).
byCar(hamilton,raglan). 
byCar(valmont,saarbruecken). 
byCar(valmont,metz). 

byTrain(metz,frankfurt). 
byTrain(saarbruecken,frankfurt). 
byTrain(metz,paris). 
byTrain(saarbruecken,paris). 

byPlane(frankfurt,bangkok). 
byPlane(frankfurt,singapore). 
byPlane(paris,losAngeles). 
byPlane(bangkok,auckland). 
byPlane(singapore,auckland). 
byPlane(losAngeles,auckland).

voyage(X,Y):- byCar(X,Y).
voyage(X,Y):- byTrain(X,Y).
voyage(X,Y):- byPlane(X,Y).

voyage(X,Y):- byCar(X,Z), voyage(Z,Y).
voyage(X,Y):- byTrain(X,Z), voyage(Z,Y).
voyage(X,Y):- byPlane(X,Z), voyage(Z,Y).

voyage(X,Y,go(byCar(X,Y))):- byCar(X,Y).
voyage(X,Y,go(byTrain(X,Y))):- byTrain(X,Y).
voyage(X,Y,go(byPlane(X,Y))):- byPlane(X,Y).

voyage(X,Y,go(byCar(X,Z),A)):- byCar(X,Z), voyage(Z,Y,A).
voyage(X,Y,go(byTrain(X,Z),A)):- byTrain(X,Z), voyage(Z,Y,A).
voyage(X,Y,go(byPlane(X,Z),A)):- byPlane(X,Z), voyage(Z,Y,A).