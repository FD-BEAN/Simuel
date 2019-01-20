clear;clc;
% base_unit = permn(1:4,12);
% 
% primary_1 = [ones(16777216,1),base_unit];
% secondary_1 = [ones(16777216,1),primary_1];
% secondary_2 = [2*ones(16777216,1),primary_1];
% secondary_3 = [3*ones(16777216,1),primary_1];
% secondary_4 = [4*ones(16777216,1),primary_1];
% save('C:\Users\SF314-51-71UP\Desktop\sec1.mat','secondary_1','secondary_2','secondary_3','secondary_4');
% clear primary_1 secondary_1 secondary_2 secondary_3 secondary_4;
% 
% primary_2 = [2*ones(16777216,1),base_unit];
% secondary_5 = [ones(16777216,1),primary_2];
% secondary_6 = [2*ones(16777216,1),primary_2];
% secondary_7 = [3*ones(16777216,1),primary_2];
% secondary_8 = [4*ones(16777216,1),primary_2];
% save('C:\Users\SF314-51-71UP\Desktop\sec2.mat','secondary_5','secondary_6','secondary_7','secondary_8');
% clear primary_2 secondary_5 secondary_6 secondary_7 secondary_8;
% 
% primary_3 = [3*ones(16777216,1),base_unit];
% secondary_9 = [ones(16777216,1),primary_3];
% secondary_10 = [2*ones(16777216,1),primary_3];
% secondary_11 = [3*ones(16777216,1),primary_3];
% secondary_12 = [4*ones(16777216,1),primary_3];
% save('C:\Users\SF314-51-71UP\Desktop\sec3.mat','secondary_9','secondary_10','secondary_11','secondary_12');
% clear primary_3 secondary_9 secondary_10 secondary_11 secondary_12;
% 
% primary_4 = [4*ones(16777216,1),base_unit];
% secondary_13 = [ones(16777216,1),primary_4];
% secondary_14 = [2*ones(16777216,1),primary_4];
% secondary_15 = [3*ones(16777216,1),primary_4];
% secondary_16 = [4*ones(16777216,1),primary_4];
% save('C:\Users\SF314-51-71UP\Desktop\sec4.mat','secondary_13','secondary_14','secondary_15','secondary_16');
% clear primary_4 secondary_13 secondary_14 secondary_15 secondary_16;

% clear base_unit

%%
load('C:\Users\SF314-51-71UP\Desktop\sec1.mat');

tertiary_1 = [ones(16777216,1),secondary_1];
save('C:\Users\SF314-51-71UP\Desktop\final_set_1.mat','tertiary_1');
clear tertiary_1;
tertiary_2 = [2*ones(16777216,1),secondary_1];
save('C:\Users\SF314-51-71UP\Desktop\final_set_2.mat','tertiary_2');
clear tertiary_2;
tertiary_3 = [3*ones(16777216,1),secondary_1];
save('C:\Users\SF314-51-71UP\Desktop\final_set_3.mat','tertiary_3');
clear tertiary_3;
tertiary_4 = [4*ones(16777216,1),secondary_1];
save('C:\Users\SF314-51-71UP\Desktop\final_set_4.mat','tertiary_4');
clear tertiary_4;
tertiary_5 = [ones(16777216,1),secondary_2];
save('C:\Users\SF314-51-71UP\Desktop\final_set_5.mat','tertiary_5');
clear tertiary_5;
tertiary_6 = [2*ones(16777216,1),secondary_2];
save('C:\Users\SF314-51-71UP\Desktop\final_set_6.mat','tertiary_6');
clear tertiary_6;
tertiary_7 = [3*ones(16777216,1),secondary_2];
save('C:\Users\SF314-51-71UP\Desktop\final_set_7.mat','tertiary_7');
clear tertiary_7;
tertiary_8 = [4*ones(16777216,1),secondary_2];
save('C:\Users\SF314-51-71UP\Desktop\final_set_8.mat','tertiary_8');
clear tertiary_8;
tertiary_9 = [ones(16777216,1),secondary_3];
save('C:\Users\SF314-51-71UP\Desktop\final_set_9.mat','tertiary_9');
clear tertiary_9;
tertiary_10 = [2*ones(16777216,1),secondary_3];
save('C:\Users\SF314-51-71UP\Desktop\final_set_10.mat','tertiary_10');
clear tertiary_10;
tertiary_11 = [3*ones(16777216,1),secondary_3];
save('C:\Users\SF314-51-71UP\Desktop\final_set_11.mat','tertiary_11');
clear tertiary_11;
tertiary_12 = [4*ones(16777216,1),secondary_3];
save('C:\Users\SF314-51-71UP\Desktop\final_set_12.mat','tertiary_12');
clear tertiary_12;
tertiary_13 = [ones(16777216,1),secondary_4];
save('C:\Users\SF314-51-71UP\Desktop\final_set_13.mat','tertiary_13');
clear tertiary_13;
tertiary_14 = [2*ones(16777216,1),secondary_4];
save('C:\Users\SF314-51-71UP\Desktop\final_set_14.mat','tertiary_14');
clear tertiary_14;
tertiary_15 = [3*ones(16777216,1),secondary_4];
save('C:\Users\SF314-51-71UP\Desktop\final_set_15.mat','tertiary_15');
clear tertiary_15;
tertiary_16 = [4*ones(16777216,1),secondary_4];
save('C:\Users\SF314-51-71UP\Desktop\final_set_16.mat','tertiary_16');
clear tertiary_16;

clear secondary_1 secondary_2 secondary_3 secondary_4



%%


load('C:\Users\SF314-51-71UP\Desktop\sec2.mat');

tertiary_17 = [ones(16777216,1),secondary_5];
save('C:\Users\SF314-51-71UP\Desktop\final_set_17.mat','tertiary_17');
clear tertiary_17;
tertiary_18 = [2*ones(16777216,1),secondary_5];
save('C:\Users\SF314-51-71UP\Desktop\final_set_18.mat','tertiary_18');
clear tertiary_18;
tertiary_19 = [3*ones(16777216,1),secondary_5];
save('C:\Users\SF314-51-71UP\Desktop\final_set_19.mat','tertiary_19');
clear tertiary_19;
tertiary_20 = [4*ones(16777216,1),secondary_5];
save('C:\Users\SF314-51-71UP\Desktop\final_set_20.mat','tertiary_20');
clear tertiary_20;
tertiary_21 = [ones(16777216,1),secondary_6];
save('C:\Users\SF314-51-71UP\Desktop\final_set_21.mat','tertiary_21');
clear tertiary_21;
tertiary_22 = [2*ones(16777216,1),secondary_6];
save('C:\Users\SF314-51-71UP\Desktop\final_set_22.mat','tertiary_22');
clear tertiary_22;
tertiary_23 = [3*ones(16777216,1),secondary_6];
save('C:\Users\SF314-51-71UP\Desktop\final_set_23.mat','tertiary_23');
clear tertiary_23;
tertiary_24 = [4*ones(16777216,1),secondary_6];
save('C:\Users\SF314-51-71UP\Desktop\final_set_24.mat','tertiary_24');
clear tertiary_24;
tertiary_25 = [ones(16777216,1),secondary_7];
save('C:\Users\SF314-51-71UP\Desktop\final_set_25.mat','tertiary_25');
clear tertiary_25;
tertiary_26 = [2*ones(16777216,1),secondary_7];
save('C:\Users\SF314-51-71UP\Desktop\final_set_26.mat','tertiary_26');
clear tertiary_26;
tertiary_27 = [3*ones(16777216,1),secondary_7];
save('C:\Users\SF314-51-71UP\Desktop\final_set_27.mat','tertiary_27');
clear tertiary_27;
tertiary_28 = [4*ones(16777216,1),secondary_7];
save('C:\Users\SF314-51-71UP\Desktop\final_set_28.mat','tertiary_28');
clear tertiary_28;
tertiary_29 = [ones(16777216,1),secondary_8];
save('C:\Users\SF314-51-71UP\Desktop\final_set_29.mat','tertiary_29');
clear tertiary_29;
tertiary_30 = [2*ones(16777216,1),secondary_8];
save('C:\Users\SF314-51-71UP\Desktop\final_set_30.mat','tertiary_30');
clear tertiary_30;
tertiary_31 = [3*ones(16777216,1),secondary_8];
save('C:\Users\SF314-51-71UP\Desktop\final_set_31.mat','tertiary_31');
clear tertiary_31;
tertiary_32 = [4*ones(16777216,1),secondary_8];
save('C:\Users\SF314-51-71UP\Desktop\final_set_32.mat','tertiary_32');
clear tertiary_32;

clear secondary_5 secondary_6 secondary_7 secondary_8




%%


load('C:\Users\SF314-51-71UP\Desktop\sec3.mat');

tertiary_33 = [ones(16777216,1),secondary_9];
save('C:\Users\SF314-51-71UP\Desktop\final_set_33.mat','tertiary_33');
clear tertiary_33;
tertiary_34 = [2*ones(16777216,1),secondary_9];
save('C:\Users\SF314-51-71UP\Desktop\final_set_34.mat','tertiary_34');
clear tertiary_34;
tertiary_35 = [3*ones(16777216,1),secondary_9];
save('C:\Users\SF314-51-71UP\Desktop\final_set_35.mat','tertiary_35');
clear tertiary_35;
tertiary_36 = [4*ones(16777216,1),secondary_9];
save('C:\Users\SF314-51-71UP\Desktop\final_set_36.mat','tertiary_36');
clear tertiary_36;
tertiary_37 = [ones(16777216,1),secondary_10];
save('C:\Users\SF314-51-71UP\Desktop\final_set_37.mat','tertiary_37');
clear tertiary_37;
tertiary_38 = [2*ones(16777216,1),secondary_10];
save('C:\Users\SF314-51-71UP\Desktop\final_set_38.mat','tertiary_38');
clear tertiary_38;
tertiary_39 = [3*ones(16777216,1),secondary_10];
save('C:\Users\SF314-51-71UP\Desktop\final_set_39.mat','tertiary_39');
clear tertiary_39;
tertiary_40 = [4*ones(16777216,1),secondary_10];
save('C:\Users\SF314-51-71UP\Desktop\final_set_40.mat','tertiary_40');
clear tertiary_40;
tertiary_41 = [ones(16777216,1),secondary_11];
save('C:\Users\SF314-51-71UP\Desktop\final_set_41.mat','tertiary_41');
clear tertiary_41;
tertiary_42 = [2*ones(16777216,1),secondary_11];
save('C:\Users\SF314-51-71UP\Desktop\final_set_42.mat','tertiary_42');
clear tertiary_42;
tertiary_43 = [3*ones(16777216,1),secondary_11];
save('C:\Users\SF314-51-71UP\Desktop\final_set_43.mat','tertiary_43');
clear tertiary_43;
tertiary_44 = [4*ones(16777216,1),secondary_11];
save('C:\Users\SF314-51-71UP\Desktop\final_set_44.mat','tertiary_44');
clear tertiary_44;
tertiary_45 = [ones(16777216,1),secondary_12];
save('C:\Users\SF314-51-71UP\Desktop\final_set_45.mat','tertiary_45');
clear tertiary_45;
tertiary_46 = [2*ones(16777216,1),secondary_12];
save('C:\Users\SF314-51-71UP\Desktop\final_set_46.mat','tertiary_46');
clear tertiary_46;
tertiary_47 = [3*ones(16777216,1),secondary_12];
save('C:\Users\SF314-51-71UP\Desktop\final_set_47.mat','tertiary_47');
clear tertiary_47;
tertiary_48 = [4*ones(16777216,1),secondary_12];
save('C:\Users\SF314-51-71UP\Desktop\final_set_48.mat','tertiary_48');
clear tertiary_48;

clear secondary_9 secondary_10 secondary_11 secondary_12




%%


load('C:\Users\SF314-51-71UP\Desktop\sec4.mat');

tertiary_49 = [ones(16777216,1),secondary_13];
save('C:\Users\SF314-51-71UP\Desktop\final_set_49.mat','tertiary_49');
clear tertiary_49;
tertiary_50 = [2*ones(16777216,1),secondary_13];
save('C:\Users\SF314-51-71UP\Desktop\final_set_50.mat','tertiary_50');
clear tertiary_50;
tertiary_51 = [3*ones(16777216,1),secondary_13];
save('C:\Users\SF314-51-71UP\Desktop\final_set_51.mat','tertiary_51');
clear tertiary_51;
tertiary_52 = [4*ones(16777216,1),secondary_13];
save('C:\Users\SF314-51-71UP\Desktop\final_set_52.mat','tertiary_52');
clear tertiary_52;
tertiary_53 = [ones(16777216,1),secondary_14];
save('C:\Users\SF314-51-71UP\Desktop\final_set_53.mat','tertiary_53');
clear tertiary_53;
tertiary_54 = [2*ones(16777216,1),secondary_14];
save('C:\Users\SF314-51-71UP\Desktop\final_set_54.mat','tertiary_54');
clear tertiary_54;
tertiary_55 = [3*ones(16777216,1),secondary_14];
save('C:\Users\SF314-51-71UP\Desktop\final_set_55.mat','tertiary_55');
clear tertiary_55;
tertiary_56 = [4*ones(16777216,1),secondary_14];
save('C:\Users\SF314-51-71UP\Desktop\final_set_56.mat','tertiary_56');
clear tertiary_56;
tertiary_57 = [ones(16777216,1),secondary_15];
save('C:\Users\SF314-51-71UP\Desktop\final_set_57.mat','tertiary_57');
clear tertiary_57;
tertiary_58 = [2*ones(16777216,1),secondary_15];
save('C:\Users\SF314-51-71UP\Desktop\final_set_58.mat','tertiary_58');
clear tertiary_58;
tertiary_59 = [3*ones(16777216,1),secondary_15];
save('C:\Users\SF314-51-71UP\Desktop\final_set_59.mat','tertiary_59');
clear tertiary_59;
tertiary_60 = [4*ones(16777216,1),secondary_15];
save('C:\Users\SF314-51-71UP\Desktop\final_set_60.mat','tertiary_60');
clear tertiary_60;
tertiary_61 = [ones(16777216,1),secondary_16];
save('C:\Users\SF314-51-71UP\Desktop\final_set_61.mat','tertiary_61');
clear tertiary_61;
tertiary_62 = [2*ones(16777216,1),secondary_16];
save('C:\Users\SF314-51-71UP\Desktop\final_set_62.mat','tertiary_62');
clear tertiary_62;
tertiary_63 = [3*ones(16777216,1),secondary_16];
save('C:\Users\SF314-51-71UP\Desktop\final_set_63.mat','tertiary_63');
clear tertiary_63;
tertiary_64 = [4*ones(16777216,1),secondary_16];
save('C:\Users\SF314-51-71UP\Desktop\final_set_64.mat','tertiary_64');
clear tertiary_64;

clear secondary_13 secondary_14 secondary_15 secondary_16