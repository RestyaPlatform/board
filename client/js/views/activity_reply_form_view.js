/**
 * @fileOverview This file has functions related to activity reply view. This view calling from modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: activitiy model and it's related values
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ActivityReplyForm View
 * @class ActivityReplyFormView
 * @constructor
 * @extends Backbone.View
 */
App.ActivityReplyFormView = Backbone.View.extend({
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
    converter: new showdown.Converter({
        extensions: ['targetblank', 'xssfilter', 'codehighlight']
    }),
    template: JST['templates/activity_reply_form'],
    tagName: 'form',
    className: 'js-add-comment panel-body js-reply-form',
    id: 'AddActivityForm',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-show-replyComment': 'showReplyComment',
        'click .js-preview-replyComment': 'previewReplyComment'
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        var self = this;
        this.converter.setFlavor('github');
        var card = self.model.cards.findWhere({
            id: parseInt(self.model.attributes.card_id)
        });
        this.$el.html(this.template({
            activity: this.model,
            card: card
        }));
        this.showTooltip();
        return this;
    },
    /**
     * showReplyComment()
     * show textarea for comment
     * @param e
     * @type Object(DOM event)
     *
     */
    showReplyComment: function(e) {
        e.preventDefault();
        var target = e.currentTarget;
        var commentId = $(target).attr("data-id");
        if (!$('.show-replyComment-' + commentId).hasClass('active')) {
            $('.show-replyComment-' + commentId).addClass('active');
            $('.preview-replyComment-' + commentId).removeClass('active');
        }
        $(target).parents('.js-reply-form').find('textarea#inputAddComment').removeClass('hide').addClass('show');
        $(target).parents('.js-reply-form').find('.js-card-replyComment-preview-panel').removeClass('show').addClass('hide');
    },
    /**
     * previewReplyComment()
     * show html formatted comment
     * @param e
     * @type Object(DOM event)
     *
     */
    previewReplyComment: function(e) {
        e.preventDefault();
        var target = e.currentTarget;
        var commentId = $(target).attr("data-id");
        $('.show-replyComment-' + commentId).removeClass('active');
        $('.preview-replyComment-' + commentId).addClass('active');
        if ($(target).parents('.js-reply-form').find('textarea#inputAddComment').hasClass('show')) {
            $(target).parents('.js-reply-form').find('textarea#inputAddComment').removeClass('show').addClass('hide');
        } else {
            $(target).parents('.js-reply-form').find('textarea#inputAddComment').addClass('hide');
        }
        var value = $(target).parents('.js-reply-form').find('textarea#inputAddComment').val();
        if (value !== "") {
            $(target).parents('.js-reply-form').find('.js-card-replyComment-preview').html(this.converter.makeHtml(value));
        } else {
            $(target).parents('.js-reply-form').find('.js-card-replyComment-preview').html("<p>Nothing to preview</p>");
        }
        $(target).parents('.js-reply-form').find('.js-card-replyComment-preview-panel').removeClass('hide').addClass('show');
        emojify.run();
    }
});
