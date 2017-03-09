#!bin/bash
function createDB(){
  echo "Enter Database Name: "
  read dbName
  cd $PWD
  mkdir $dbName
  if [ $? == 0 ]
  then
    echo 'database created Successfully!!"'
  else
    echo 'failed to create database'
  fi
}

function renameDB(){
  read -p "enter the old database name" olddatabase
	read  -p "enter the New database name" newdatabase
  mv $olddatabase  $newdatabase
  if [ $? == 0 ]
  then
	   echo "Datebase renamed Successfully !!"
  else
    echo "failed to rename database"
  fi
}
function deleteDB(){
  read -p "enter the name of database you want to delete" db1
   rm  -R $db1
   if [ $?==0 ]
   then
	    echo "Datebase deleted  Successfully !!"
   else
     echo "datbase failed to deleted"
  fi
}

function UseDb(){
  ls  $PWD
	read -p "enter Database Name you want to use" db
	cd $db
  if [ $? == 0 ]
  then
    echo 'database used!!"'
    select chioce in MeunTable  Exit
      do
        case $chioce in
           MeunTable)
              select chioce in  Create Insert Update  DeleteRecord Delete Select Exit
              do
                case $chioce in
                  Create) creatTable;;
                  Insert) insertValueIntoTable;;
                  Update) UpdateColum;;
                  DeleteRecord) deleteRecord;;
                  Delete)deletetable;;
                  Select) select choose in selectAll selectColumn selectwithCondition doOperation Exit
                  do
                    case  $choose in
                        selectAll) selectAllFromCol;;
                        selectColumn) selectColumn;;
                        selectwithCondition) selectwithconditon;;
                        doOperation) operation;;
                        Exit) break;;
                    esac
                done
                  ;;
                  Exit) break;;
                esac
              done;;
            Exit) exit;;
        esac
      done
  else
    echo 'failed to use database'
  fi
}

function creatTable(){
  read -p "enter table name " tableName
  touch $tableName
  if [ $? == 0 ]
  then
    echo 'table created!!'
  fi
  read -p "enter no of colums you want" noCol
  for (( i=0; i < $noCol; i=i+1 )); do
  		read -p "enter name of colum :" colName
      read -p "enter dataType of colum :" colType
      echo -n  $colName":" >> $tableName.txt
      echo  $colType ":" >> $tableName.txt
      echo  -n $colName":" >> $tableName
  done
   echo " ">>$tableName
}
function deletetable(){
  read -p "enter table name you want to delete" tableName
  rm $tableName
  if [ $? == 0 ]
  then
    echo 'table deleted!'
  fi
}
function insertValueIntoTable(){
  read  -p "enter table Name :" tableName
  numofcols=$(awk -F: '{if(NR==1)print NF}' $tableName)

  for (( i = 1; i < $numofcols; i++ ));
  do
    fieldName=$(awk -F: -v var=${i} '{if(NR==1)print $var}' $tableName)
    echo "Enter Value of $fieldName  "
    read values[$i-1]

  done

  for (( i = 0; i < $numofcols; i++ ));
  do
    if [[ i -eq numofcols-1 ]]; then
      echo  ${values[$i]}>>$tableName
    else
      echo -n ${values[$i]}: >>$tableName
    fi
  done
}
function selectAllFromCol(){
  read -p "enter Table Name" tableName
  awk  -F: '{print $0}' $tableName
}

function  selectColumn(){
  read -p "enter Table Name " tableName
  read -p "enter the column Name " colName
  fieldNum=$(awk -F:  -v colname=$colName 'BEGIN{colnum=0}{if(NR==1){for(i=0;i<NF;i++){if(colname==$i){colnum=i}}}} END{print colnum}' $tableName)
  awk -F: -v fieldnum=$fieldNum '{print $fieldnum}' $tableName
}

function selectwithconditon(){
   numberOfRecord=$(getNumRecord)
   awk -F: '{if(NR =='$numberOfRecord') print $NR}' $tableName
}

function getNumRecord(){
  read -p "enter Table Name " tableName
  read -p "enter the column Name " colName
  fieldNum=$(awk -F:  -v colname=$colName 'BEGIN{colnum=0}{if(NR==1){for(i=0;i<NF;i++){if(colname==$i){colnum=i}}}} END{print colnum }' $tableName)
  read -p "value in colum" value
  awk -F: '{ if($'$fieldNum'=='$value') print NR }' $tableName
}

function deleteRecord(){
  numberOfRecord=$(getNumRecord)
  sed  -i $numberOfRecord'd' $tableName

}
function UpdateColum(){
  read -p "enter Table Name " tableName
  read -p "enter the column Name based on" colspecific
  read -p "value of id " value
  fieldofspecific=$(awk -F:  -v colname=$colspecific 'BEGIN{colnum=0}{if(NR==1){for(i=0;i<NF;i++){if(colname==$i){colnum=i}}}} END{print colnum }' $tableName)
  recordnum=$(awk -F: '{ if($'$fieldofspecific'=='$value') print NR }' $tableName)
  read -p "enter col to update:" colUpdate
  fieldtoupdate=$(awk -F:  -v col=$colUpdate 'BEGIN{colnum=0}{if(NR==1){for(i=0;i<NF;i++){if(col==$i){colnum=i}}}} END{print colnum }' $tableName)
  read -p "enter new value:" newValue
  oldvalue=$(awk -F: '{if($'$fieldofspecific'=='$value') print $'$fieldtoupdate'}' $tableName)
   sed -i 's/'$oldvalue'/'$newValue'/' $tableName
}
function  doOperationSum(){
  read -p "enter Table Name " tableName
  read -p "enter the column Name datatype must be int to make op " colName
  fieldNum=$(awk -F:  -v colname=$colName 'BEGIN{colnum=0}{if(NR==1){for(i=0;i<NF;i++){if(colname==$i){colnum=i}}}} END{print colnum}' $tableName)
  awk -F: -v fieldnum=$fieldNum 'BEGIN {sum=0} {sum+=$fieldnum} END{print sum}' $tableName

}
function  doOperationCountCol(){
  read -p "enter Table Name " tableName
  echo "THe Number Of Fields is "
  awk -F: '{print NF; exit}' $tableName
}

function  doOperationCountRow(){
  read -p "enter Table Name " tableName
  echo "THe Number Of Records is "
  awk 'END{print FNR-1}' $tableName
}

function operation(){
select choice in CalcSum  CalcCountCol CalcCountRow Exit
    do
      case $choice in
        CalcSum) doOperationSum ;;
	      CalcCountCol)doOperationCountCol;;
	      CalcCountRow)doOperationCountRow;;
        Exit) break;;
      esac
    done
}
function MainMeun(){
select choice in createDB UseDB RenameDB  DeleteDb  Exit
    do
      case $choice in
        createDB) createDB;;
        UseDB) UseDb;;
        RenameDB) renameDB;;
        DeleteDb) deleteDB;;
        Exit) exit;;
      esac
    done
}
MainMeun
