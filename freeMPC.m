function [Yf,R] = freeMPC(A,B,dp,y,delU,r,N1,N2,k)
  %% Creo los vectores que conforman la RESPUESTA LIBRE
      R=[];Yf=[];
      au=0;
      [Na,~]=size(A);
      [~,Nb]=size(B);
      %Multiplico pelo Delta
      for i=1:Na
          At{i,i}=conv(A{i,i},[1 -1]);
          na{i,i}=length(At{i,i})-1; 
      end
      for i=1:Na
          for j=1:Nb
              nb{i,j}=length(B{i,j}); 
          end
      end
      %Creo el vector de controles pasados basandome en la ecuacion de
      %salida del modelo de la planta actual y(k). O sea coloco en un vector
      %todos los incrementos de control de cada una de las entradas, algo como:
      %[deltaU(k-1) deltaU(k-2) ... deltaU(k-nb)] donde "nb" es
      %la longitud del vector B (Numerador del modelo)
      for i=1:Na
          for j=1:Nb
              %Controles pasados de yi en el instante actual
              dUP{i,j}=delU(j,k-dp(i,j)-1:-1:k-dp(i,j)-nb{i,j});
          end
          %Creo un vector de salidas pasadas, similar al vector de controles
          %pasados solo que en este caso con las salidas hasta la longitud del
          %polinomio A (denominador del modelo)
          yp{i}=y(i,k:-1:k-na{i,i}+1);                         % Vetor de saída
      end
      n=1; %Indice para la salida libre    
      for i=1:Na %Numero de Salidas
           nn=1;
          for j=1:N2(i) %Predicciones
              %Ahora realizo mis predicciones hasta el horizonte de predicción N2
             
              yf{n}=-yp{i}*At{i,i}(2:end)';
              for w=1:Nb %Numero de Entradas

                  if j<=dp(i,w) 
                      %Comienzo a desplazar los deltaU pasados a medida que aumento
                      %la ventana de predicción, hasta que la predicción en este
                      %vector llegue al retardo
                      dUP{i,w}=[delU(w,k-dp(i,w)-1+j) dUP{i,w}(1:end-1)];
                  elseif j>dp(i,w) 
                      %Una vez la ventana de predicción es mayor que el retardo, en
                      %la ecuación de salida dejan de existir los deltaU pasados y
                      %comenzaran a aparecer los deltaU futuros, por eso comienzo a
                      %cerar los deltaU pasados.
                      dUP{i,w}=[0 dUP{i,w}(1:end-1)];
                  end
                  %Hago el calculo de la respuesta libre con el polinomio Atil y el
                  %polinomio B, junto con las salidas pasadas y los deltaU pasados
                  yf{n}=yf{n}+dUP{i,w}*B{i,w}(1:end)';
              end
          

                  %Actualizo el vector de salidas pasadas
                  yp{i}=[yf{n} yp{i}(1:end-1)];                    % Atualiza yfr
                  Ref(nn,1)=r(i,k);
                  n=n+1;
                  nn=nn+1;
              
          end
          Af=cell2mat(yf)';
          Yf=[Yf; Af(N1(i)+(au):sum(N2(1:i)))];
          au=sum(N2(1:i));
          R=[R; Ref(N1(i):N2(i))];
      end
      
      