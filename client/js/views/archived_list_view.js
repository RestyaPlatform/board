/**
 * @fileOverview This file has functions related to archived list view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: list model and it's related values. It contain all list based object @see Available Object in App.ListView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * UserCards View
 * @class UserCardsView
 * @constructor
 * @extends Backbone.View
 */
App.ArchivedListView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/archived_list'],
    tagName: 'li',
    className: 'list-group-item clearfix',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-delete-archived-list': 'deleteArchivedList',
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
            list: this.model,
        }));
        this.showTooltip();
        return this;
    },
    /**
     * deleteArchivedList()
     * delete archived list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    deleteArchivedList: function(e) {
        e.preventDefault();
        this.model.collection.remove([{
            id: this.model.attributes.id
        }]);
        this.$el.remove();
        this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.id + '.json';
        this.model.destroy();
        return false;
    }
});
