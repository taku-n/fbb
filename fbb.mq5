#property indicator_chart_window

#property indicator_buffers 7
#property indicator_plots   7

#property indicator_label1 "FBB"
#property indicator_type1  DRAW_LINE
#property indicator_color1 clrMagenta
#property indicator_style1 STYLE_DOT
#property indicator_width1 1

#property indicator_label2 "+1σ"
#property indicator_type2  DRAW_LINE
#property indicator_color2 clrYellow
#property indicator_style2 STYLE_DOT
#property indicator_width2 1

#property indicator_label3 "-1σ"
#property indicator_type3  DRAW_LINE
#property indicator_color3 clrYellow
#property indicator_style3 STYLE_DOT
#property indicator_width3 1

#property indicator_label4 "+2σ"
#property indicator_type4  DRAW_LINE
#property indicator_color4 clrLime
#property indicator_style4 STYLE_DOT
#property indicator_width4 1

#property indicator_label5 "-2σ"
#property indicator_type5  DRAW_LINE
#property indicator_color5 clrLime
#property indicator_style5 STYLE_DOT
#property indicator_width5 1

#property indicator_label6 "+3σ"
#property indicator_type6  DRAW_LINE
#property indicator_color6 clrCyan
#property indicator_style6 STYLE_DOT
#property indicator_width6 1

#property indicator_label7 "-3σ"
#property indicator_type7  DRAW_LINE
#property indicator_color7 clrCyan
#property indicator_style7 STYLE_DOT
#property indicator_width7 1

input int PERIOD = 12;

double fbb[];
double sp1[];
double sm1[];
double sp2[];
double sm2[];
double sp3[];
double sm3[];

int OnInit()
{
	SetIndexBuffer(0, fbb, INDICATOR_DATA);
	PlotIndexSetInteger(0, PLOT_SHIFT, 1);
	PlotIndexSetString(0, PLOT_LABEL, "FBB(" + IntegerToString(PERIOD) + ")");

	SetIndexBuffer(1, sp1, INDICATOR_DATA);
	PlotIndexSetInteger(1, PLOT_SHIFT, 1);
	PlotIndexSetString(1, PLOT_LABEL, "+1σ(" + IntegerToString(PERIOD) + ")");  // Data Window

	SetIndexBuffer(2, sm1, INDICATOR_DATA);
	PlotIndexSetInteger(2, PLOT_SHIFT, 1);
	PlotIndexSetString(2, PLOT_LABEL, "-1σ(" + IntegerToString(PERIOD) + ")");  // Data Window

	SetIndexBuffer(3, sp2, INDICATOR_DATA);
	PlotIndexSetInteger(3, PLOT_SHIFT, 1);
	PlotIndexSetString(3, PLOT_LABEL, "+2σ(" + IntegerToString(PERIOD) + ")");  // Data Window

	SetIndexBuffer(4, sm2, INDICATOR_DATA);
	PlotIndexSetInteger(4, PLOT_SHIFT, 1);
	PlotIndexSetString(4, PLOT_LABEL, "-2σ(" + IntegerToString(PERIOD) + ")");  // Data Window

	SetIndexBuffer(5, sp3, INDICATOR_DATA);
	PlotIndexSetInteger(5, PLOT_SHIFT, 1);
	PlotIndexSetString(5, PLOT_LABEL, "+3σ(" + IntegerToString(PERIOD) + ")");  // Data Window

	SetIndexBuffer(6, sm3, INDICATOR_DATA);
	PlotIndexSetInteger(6, PLOT_SHIFT, 1);
	PlotIndexSetString(6, PLOT_LABEL, "-3σ(" + IntegerToString(PERIOD) + ")");  // Data Window

	return INIT_SUCCEEDED;
}

int OnCalculate(const int       TOTAL,
		const int       PREV,
		const datetime &T[],
		const double   &O[],
		const double   &H[],
		const double   &L[],
		const double   &C[],
		const long     &TICK_VOL[],
		const long     &VOL[],
		const int      &SP[])
{
	fbb(C, TOTAL, PREV);

	return TOTAL;
}

void fbb(const double &C[], const int TOTAL, const int PREV)
{
	int begin;
	if (PREV == 0) {
		begin = 0;
	} else {
		begin = PREV - 1;
	}

	for (int i = begin; i < TOTAL; i++) {
		double sigma = sd(C, i);

		fbb[i] = avg(C, i);
		sp1[i] = fbb[i] + sigma;
		sm1[i] = fbb[i] - sigma;
		sp2[i] = fbb[i] + sigma * 2;
		sm2[i] = fbb[i] - sigma * 2;
		sp3[i] = fbb[i] + sigma * 3;
		sm3[i] = fbb[i] - sigma * 3;
	}
}

// Standard Deviation
double sd(const double &C[], const int I)
{
	return MathSqrt(variance(C, I));
}

double variance(const double &C[], const int I)
{
	const double avg = avg(C, I);
	      double sum = 0.0;

	for (int i = I - (PERIOD - 1); i <= I; i++) {
		if (i < 0) {
			sum += (C[0] - avg) * (C[0] - avg);
		} else {
			sum += (C[i] - avg) * (C[i] - avg);
		}
	}

	return sum / PERIOD;
}


double avg(const double &C[], const int I)
{
	double sum = 0.0;

	for (int i = I - (PERIOD - 1); i <= I; i++) {
		if (i < 0) {
			sum += C[0];
		} else {
			sum += C[i];
		}
	}

	return sum / PERIOD;
}
