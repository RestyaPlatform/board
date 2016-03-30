/**
 * @fileOverview This file has functions related to user Music Repeat View. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * MusicRepeat View
 * @class MusicRepeatView
 * @constructor
 * @extends Backbone.View
 */
App.MusicRepeatView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {},
    continueMusic: function(e) {
        var temp = new App.MusicRepeatView();
        var music_content = App.music.music_content;
        if (!_.isUndefined(App.music) && music_content !== undefined && music_content !== '' && music_content !== null && !navigator.userAgent.match(/Trident/)) {
            App.music.inst.setTimbre({
                wave: 'piano'
            });
            if (!_.isUndefined(authuser.user)) {
                if (parseInt(authuser.user.is_productivity_beats) === 1) {
                    App.music.inst.play(
                        music_content, temp.continueMusic
                    );
                } else {
                    App.music.inst.silence();
                }
            } else {
                if (!_.isUndefined(window.sessionStorage.getItem('music_play')) && window.sessionStorage.getItem('music_play') === "1") {
                    App.music.inst.play(
                        music_content, temp.continueMusic
                    );
                } else {
                    App.music.inst.silence();
                }
            }
        }
    }
});
