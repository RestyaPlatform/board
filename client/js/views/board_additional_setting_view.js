/**
 * @fileOverview This file has functions related to board additional settings view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model. It contain all board based object @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardFilter View
 * @class BoardFilterView
 * @constructor
 * @extends Backbone.View
 */
App.BoardAdditionalSettingsView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        //this.board_labels = options.board_labels;
        this.render();
    },
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#BoardSoryBy': 'updateSortBy',
    },
    /**
     * updateSortBy()
     * save board sort_by
     * @param e
     * @type Object(DOM event)
     *
     */
    updateSortBy: function(e) {
        var target = $(e.target);
        var sort_by = target.find('.js-sort-by-group').val();
        var board = new App.Board();
        board.url = api_url + 'boards/' + this.model.id + '.json';
        App.boards.get(this.model.id).set('sort_by', sort_by);
        this.model.set('sort_by', sort_by);
        board.save({
            sort_by: sort_by,
            id: this.model.id
        },{success: function(model, response) {
            location.reload(true);
        }});
    },
    template: JST['templates/board_additional_settings'],
    tagName: 'div',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            board: this.model,
            //board_labels: this.board_labels,
        }));
        this.showTooltip();
        return this;
    }
});
