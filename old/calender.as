#module
	
		#define ctype strtest(%1) ((((%1)>=129)&((%1)<=159))|(((%1)>=224)&((%1)<=252)))
		
		//MStrlen(p1,p2,p3)
		//	p1=文字列型の変数名
		//	p2=文字数インデックス(バイト数ではない)
		//	p3=機能切り替え 0=p1内の文字数を返す 1=p2のインデックスをバイト単位で返す
		//p2,p3を省略するとp3=0として動作
		#defcfunc  MStrlen var buf,int Index,int sw,local in
		repeat 
			temp=peek(buf,cnt)
			if (temp=0) or ((Index<=in)*sw) {byte=cnt : break}
			in++ :continue cnt+strtest(temp)+1
		loop
		if sw{return byte}else{return in}
		
		//MStrmid(p1,p2,p3)
		//	p2,p3が文字数単位になったStrmid
		#defcfunc  MStrmid var buf,int Index,int i,local in
		byte=MStrlen(buf,Index,1)
		repeat i
			temp=peek(buf,byte+in)
			if temp=0 {break}
			in+=strtest(temp)+1
		loop
		return strmid(buf,byte,in)
		
	#global
	#module Calender
		
		#deffunc LoadHolydaysCSV var LoadHolydaysCSV_note
			
			httpload "https://www8.cao.go.jp/chosei/shukujitsu/" + "syukujitsu.csv"
			
			if (stat = 0) {
				repeat
					httpinfo LoadHolydaysCSV_res, HTTPINFO_MODE
					if (LoadHolydaysCSV_res = HTTPMODE_READY) {
						
						LoadHolydaysCSV_success = 1
						break
						
					}
					if LoadHolydaysCSV_res <= HTTPMODE_NONE {
						
						httpinfo LoadHolydaysCSV_error, HTTPINFO_ERROR
						dialog LoadHolydaysCSV_error, , "Error"
						end
						
					}
					await 16
				loop
			}
			
			notesel LoadHolydaysCSV_note
		
			if LoadHolydaysCSV_success {

				httpinfo LoadHolydaysCSV_note, HTTPINFO_DATA
				
			}
			return

		#defcfunc GetHolydays int GetHolydays_year, int GetHolydays_month, int GetHolydays_day

			GetHolydays_find = notefind((str(GetHolydays_year) + "/" + str(GetHolydays_month) + "/" + str(GetHolydays_day) + ","), 2)

			if (GetHolydays_find != -1) {
				
				noteget GetHolydays_holyday, GetHolydays_find
				GetHolydays_find = instr(GetHolydays_holyday, 0, ",") + 1
				GetHolydays_holyday = strmid(GetHolydays_holyday, GetHolydays_find, strlen(GetHolydays_holyday))

			} else {

				GetHolydays_holyday = -1

			}

			return GetHolydays_holyday
			
			
		#defcfunc FloorFunction double FloorFunction_in

			FloorFunction_number = double(FloorFunction_in)
			
			if (FloorFunction_number < 0) {
				if (FloorFunction_number != int(FloorFunction_number)) {
						
					FloorFunction_number = int(FloorFunction_number) - 1
				}
					
			} else {
		
				FloorFunction_number = int(FloorFunction_number)
		
			}
			return FloorFunction_number

		#defcfunc ModuloOperation double ModuloOperation_in, double ModuloOperation_mod

			ModuloOperation_number = ModuloOperation_in

			repeat

				if ((ModuloOperation_number \ ModuloOperation_mod) < 0) {

					ModuloOperation_number += ModuloOperation_mod

				} else {

					break

				}
				await

			loop

			return ModuloOperation_number \ ModuloOperation_mod

		#defcfunc GetMaxDay int GetMaxDay_year, int GetMaxDay_month

			switch (GetMaxDay_month)

				case 1 : return 31 : swbreak
				
				case 2

					if ((GetMaxDay_year \ 4)  = 0) {

						if ((GetMaxDay_year \ 100) = 0) and ((GetMaxDay_year \ 400) != 0) {

							return 28

						} else {

							return 29

						}
						
					} else {

						return 28

					}

				swbreak
				
				case 3 : return 31 : swbreak
				case 4 : return 30 : swbreak
				case 5 : return 31 : swbreak
				case 6 : return 30 : swbreak
				case 7 : return 31 : swbreak
				case 8 : return 31 : swbreak
				case 9 : return 30 : swbreak
				case 10 : return 31 : swbreak
				case 11 : return 30 : swbreak
				case 12 : return 31 : swbreak

			swend

				

		#defcfunc GetDayOfWeek int GetDayOfWeek_mode, int GetDayOfWeek_year, int GetDayOfWeek_month, int GetDayOfWeek_day
			
			if (GetDayOfWeek_month < 3) {
		
				GetDayOfWeek_Dyear = GetDayOfWeek_year - 1
				GetDayOfWeek_Dmonth = GetDayOfWeek_month + 12
		
			} else {
		
				GetDayOfWeek_Dyear = GetDayOfWeek_year
				GetDayOfWeek_Dmonth = GetDayOfWeek_month
		
			}
			GetDayOfWeek_dow = int(ModuloOperation((GetDayOfWeek_Dyear + FloorFunction(GetDayOfWeek_Dyear / 4) - FloorFunction(GetDayOfWeek_Dyear / 100) + FloorFunction(GetDayOfWeek_Dyear / 400) + FloorFunction(((13 * GetDayOfWeek_Dmonth) + 8) / 5) + GetDayOfWeek_day), 7))

			switch (GetDayOfWeek_mode)

				case 0

					GetDayOfWeek_dayofweek = GetDayOfWeek_dow

				swbreak
				
				case 1

					switch (GetDayOfWeek_dow)

						case 0 : GetDayOfWeek_dayofweek = "Sun." : swbreak
						case 1 : GetDayOfWeek_dayofweek = "Mon." : swbreak
						case 2 : GetDayOfWeek_dayofweek = "Tue." : swbreak
						case 3 : GetDayOfWeek_dayofweek = "Wed." : swbreak
						case 4 : GetDayOfWeek_dayofweek = "Thu." : swbreak
						case 5 : GetDayOfWeek_dayofweek = "Fri." : swbreak
						case 6 : GetDayOfWeek_dayofweek = "Sat." : swbreak

					swend

				swbreak

				case 2

					switch (GetDayOfWeek_dow)

						case 0 : GetDayOfWeek_dayofweek = "日" : swbreak
						case 1 : GetDayOfWeek_dayofweek = "月" : swbreak
						case 2 : GetDayOfWeek_dayofweek = "火" : swbreak
						case 3 : GetDayOfWeek_dayofweek = "水" : swbreak
						case 4 : GetDayOfWeek_dayofweek = "木" : swbreak
						case 5 : GetDayOfWeek_dayofweek = "金" : swbreak
						case 6 : GetDayOfWeek_dayofweek = "土" : swbreak

					swend

				swbreak

			swend

			return GetDayOfWeek_dayofweek

		#deffunc DayFormat var DayFormat_year, var DayFormat_month, var DayFormat_day

			if (DayFormat_day < 1) {
				
				if ((DayFormat_month - 1) = 0) {
					
					DayFormat_day += GetMaxDay(DayFormat_year - 1, 12)
					
				} else {
					
					DayFormat_day += GetMaxDay (DayFormat_year, DayFormat_month - 1)
				}
				
			} else : if (GetMaxDay(DayFormat_year, DayFormat_month) < DayFormat_day) {
				
				DayFormat_day -= GetMaxDay(DayFormat_year, DayFormat_month)
				
			}

			if (DayFormat_month < 1) {

				DayFormat_year -= 1
				DayFormat_month += 12

			}

			if (12 < DayFormat_month) {

				DayFormat_year += 1
				DayFormat_month -= 12

			}
			
			return

		#deffunc AllFormat var AllFormat_year, var AllFormat_month, var AllFormat_day
			
			if (AllFormat_day < 1) {

				if (AllFormat_month -1 = 0) {

					AllFormat_yaer -= 1
					AllFormat_month = 12
					AllFormat_day += GetMaxDay(AllFormat_year, AllFormat_month)

				} else {

					AllFormat_month -= 1
					AllFormat_day += GetMaxDay(AllFormat_year, AllFormat_month)

				}

			} else : if(GetMaxDay(AllFormat_year, AllFormat_month) < AllFormat_day) {

				if (AllFormat_month + 1 = 13) {

					AllFormat_year += 1
					AllFormat_month = 1
					AllFormat_day -= GetMaxDay(AllFormat_year - 1, 12)

				} else {

					AllFormat_month += 1
					AllFormat_day -= GetMaxDay(AllFormat_year, AllFormat_month - 1)

				}
			}
			return
						

	#global