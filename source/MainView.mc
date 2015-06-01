using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class MainView extends Ui.View {

	//! Load your resources here
	function onLayout(dc) {
		//setLayout(Rez.Layouts.MainLayout(dc));
	}

	//! Restore the state of the app and prepare the view to be shown
	function onShow() {
	}

	function drawWelcomeScreen(dc) {
		setLayout(Rez.Layouts.WelcomeLayout(dc));

		//update localized text
		findDrawableById("welcome_who_start_label").setText(Rez.Strings.welcome_who_start);
		findDrawableById("welcome_opponent_up_label").setText(Rez.Strings.welcome_opponent_up);
		findDrawableById("welcome_you_down_label").setText(Rez.Strings.welcome_you_down);
		findDrawableById("welcome_random_label").setText(Rez.Strings.welcome_random);

		//call the parent onUpdate function to redraw the layout
		View.onUpdate(dc);
	}

	function drawFinalScreen(dc, winner) {
		setLayout(Rez.Layouts.FinalLayout(dc));

		//draw end of match text
		var wonText = Ui.loadResource(winner == :player_1 ? Rez.Strings.end_you_won : Rez.Strings.end_opponent_won);
		findDrawableById("final_won_text").setText(wonText);
		//draw score
		findDrawableById("final_score").setText(match.getScore(:player_1).toString() + " - " + match.getScore(:player_2).toString());
		//draw match time
		findDrawableById("final_time").setText(Helpers.formatDuration(match.getDuration()));
		//draw strokes
		var strokesText = Ui.loadResource(Rez.Strings.end_total_strokes);
		findDrawableById("final_strokes").setText(Helpers.formatString(strokesText, {"strokes" => match.getStrokesNumber().toString()}));

		//call the parent onUpdate function to redraw the layout
		View.onUpdate(dc);
	}

	function drawMatchScreen(dc) {
		var xCenter = dc.getWidth() / 2;
		var yCenter = dc.getHeight() / 2;

		var highlighted_corner_index = match.getHighlightedCorner();
		Sys.println("highlighted corner index " + highlighted_corner_index);
		//draw corner 0
		dc.setColor(highlighted_corner_index == 0 ? Gfx.COLOR_DK_GREEN : Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon([[68,20], [xCenter - 2,20], [xCenter - 2,80], [50,80]]);
		//draw corner 1
		dc.setColor(highlighted_corner_index == 1 ? Gfx.COLOR_DK_GREEN : Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon([[xCenter + 2,20], [152,20], [170,80], [xCenter + 2,80]]);
		//draw corner 2
		dc.setColor(highlighted_corner_index == 2 ? Gfx.COLOR_DK_GREEN : Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon([[49,85], [xCenter - 2,85], [xCenter - 2,160], [30,160]]);
		//draw corner 3
		dc.setColor(highlighted_corner_index == 3 ? Gfx.COLOR_DK_GREEN : Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon([[xCenter + 2,85], [171,85], [190,160], [xCenter + 2,160]]);

		//draw scores container
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
		//player 1 (watch carrier)
		dc.fillRoundedRectangle(xCenter - 25, 94, 50, 58, 5);
		//player 2 (opponent)
		dc.fillRoundedRectangle(xCenter - 20, 29, 40, 42, 5);
		//draw scores
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		//player 1 (watch carrier)
		dc.drawText(xCenter, 89, Gfx.FONT_NUMBER_MEDIUM, match.getScore(:player_1).toString(), Gfx.TEXT_JUSTIFY_CENTER);
		//player 2 (opponent)
		dc.drawText(xCenter, 29, Gfx.FONT_NUMBER_MILD, match.getScore(:player_2).toString(), Gfx.TEXT_JUSTIFY_CENTER);

		//draw timer
		dc.drawText(xCenter, 170, Gfx.FONT_SMALL, Helpers.formatDuration(match.getDuration()), Gfx.TEXT_JUSTIFY_CENTER);
	}

	//! Update the view
	function onUpdate(dc) {
		if(!match.hasBegun()) {
			drawWelcomeScreen(dc);
		}
		else {
			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
			dc.clear();

			var winner = match.getWinner();
			if(winner != null) {
				drawFinalScreen(dc, winner);
			}
			else {
				drawMatchScreen(dc);
			}
		}
	}

	//! Called when this View is removed from the screen. Save the
	//! state of your app here.
	function onHide() {
	}

}