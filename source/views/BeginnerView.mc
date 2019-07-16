using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Math as Math;

class BeginnerView extends Ui.View {

	function initialize() {
		View.initialize();
	}

	function onLayout(dc) {
		setLayout(Rez.Layouts.beginner(dc));
	}
}

class BeginnerViewDelegate extends Ui.BehaviorDelegate {

	hidden var view;

	function initialize(view) {
		BehaviorDelegate.initialize();
		self.view = view;
	}

	function manageRandomChoice() {
		var beginner = Math.rand() % 2 == 0 ? :player_1 : :player_2;
		manageChoice(beginner);
	}

	function manageChoice(player) {
		//create match
		var type = $.config[:type];
		var sets_number = $.config[:sets_number];

		var app = Application.getApp();
		var mp = app.getProperty("maximum_points");
		var amp = app.getProperty("absolute_maximum_points");

		$.match = new Match(type, sets_number, player, mp, amp, app);

		Ui.switchToView(new MatchView(), new MatchViewDelegate(), Ui.SLIDE_IMMEDIATE);
	}

	function onKey(key) {
		if(key.getKey() == Ui.KEY_ENTER) {
			//do not enable enter key on touch watches
			if(!$.device.isTouchScreen) {
				//begin match with random player
				manageRandomChoice();
				return true;
			}
		}
		return false;
	}

	function onNextPage() {
		//begin match with player 1 (watch carrier)
		manageChoice(:player_1);
		return true;
	}

	function onPreviousPage() {
		//begin match with player 2 (opponent)
		manageChoice(:player_2);
		return true;
	}

	function onBack() {
		//return to type screen and push set screen over because it is not possible to swith to a picker view
		var view = new TypeView();
		Ui.switchToView(view, new TypeViewDelegate(view), Ui.SLIDE_IMMEDIATE);
		Ui.pushView(new SetPicker(), new SetPickerDelegate(), Ui.SLIDE_IMMEDIATE);
		return true;
	}

	function onTap(event) {
		var random = view.findDrawableById("beginner_random");
		var opponent = view.findDrawableById("beginner_opponent");
		var you = view.findDrawableById("beginner_you");
		var tapped = UIHelpers.findTappedDrawable(event, [random, opponent, you]);
		if(opponent.equals(tapped)) {
			manageChoice(:player_2);
		}
		else if(you.equals(tapped)) {
			manageChoice(:player_1);
		}
		else {
			manageRandomChoice();
		}
		return true;
	}
}