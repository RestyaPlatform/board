/**
 * @fileOverview This file has functions related to modal board view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model. @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ModalBoard View
 * @class ModalMusicView
 * @constructor
 * @extends Backbone.View
 */
App.ModalMusicView = Backbone.View.extend({
    id: 'music-modal',
    className: '',
    template: JST['templates/modal_music_view'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#js-MusicForm': 'addMusic'
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {},
    /**
     * addMusic()
     * Update music
     * @param NULL
     * @return object
     *
     */
    addMusic: function() {
        var self = this;
        var music_name = $('.js-music_name').val();
        var music_content = $('.js-music_content').val();
        this.model.url = api_url + 'boards/' + this.model.id + '.json';
        this.model.set('music_name', music_name);
        this.model.set('music_content', music_content);
        data = {
            music_name: music_name,
            music_content: music_content
        };
        this.model.save(data, {
            patch: true,
            success: function(model, response) {
                var view = new Backbone.View();
                view.flash('success', i18next.t('Updated successfully.'));
                $('#music-modal').modal('hide');
                $('div.modal-backdrop').remove();
                if (!_.isEmpty(music_name) && music_name != 'NULL') {
                    App.music.music_name = music_name;
                }
                if (!_.isEmpty(music_content) && music_content != 'NULL') {
                    App.music.music_content = music_content;
                    var temp = new App.MusicRepeatView();
                    temp.continueMusic();
                } else {
                    App.music.inst.silence();
                }
                self.footerView = new App.FooterView({
                    model: authuser,
                    board_id: self.model.id
                }).render();
                $('#footer').html(self.footerView.el);
                self.showTooltip();
            }
        });

        return false;
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            list: this.model
        }));
        this.$el.modal({
            show: true,
            backdrop: false
        });
        this.showTooltip();
        return this;
    },
    /**
     * show()
     * display list attachment in modal box
     *
     */
    show: function() {
        this.render();
        this.$el.find('#modalMusic').modal('show');
        $('.js-music_name').val(this.model.attributes.music_name);
        $('.js-music_content').val(this.model.attributes.music_content);
    },
    /**
     * closePopup()
     * hide displayed dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('#flickr-modal').remove();
        return false;
    }
});
