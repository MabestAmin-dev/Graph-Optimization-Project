% läs in indatafil
load(input('Ange datafil: ','s'));

tic % ta tid

x = zeros(size(c));  % x-matris med flöden mellan fabrik och kund.
y = zeros(size(f));  % y-vektor med ettor för fabriker som ska byggas

disp(sprintf('Antal fabriker: %d, antal kunder: %d',m,n));
disp(sprintf('Total kapacitet: %d, total efterfrågan: %d',sum(s),sum(d)));

ss=s;      % återstående fabrikskapacitet, minska då transporter sker
dd=d;      % återstående efterfrågan, minska då transporter sker
cc=c;      % temp c, kan ändras
ff=f;      % temp f, kan ändras
           % ss,dd,cc,ff kan ändras, s,d,f,c bör ej ändras

% sätt värdet på e
e=1;

while sum(dd)>0    %loopa till alla kunders efterfrågan är uppfylld

    % välj fabrik, välj kund, skicka, på billigaste sätt
    % uppdatera x, y, ss och dd, samt ev ff och cc


end

disp(sprintf('Antal fabriker byggda: %d',sum(y)));
cost=sum(sum(c.*x)) + e*sum(f.*y);
fprintf('Totalkostnad: %.2f\n', cost);
str0=sprintf('%d ',y);
disp(sprintf('Byggda fabriker: %s',str0));

toc % ta tid
