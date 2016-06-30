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
