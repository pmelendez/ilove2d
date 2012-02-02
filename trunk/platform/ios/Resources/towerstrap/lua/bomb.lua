//Ŀ���ٶ�
var speed:Number = 12;
//Ŀ�ĵ�λ��
var pos:Point = new Point(300,250);
//�����ٶ�
var misslespeed:Number = 10;
//���ٶ�
var omega:Number = 8;
//��Ӵ����¼�
stage.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
mcTarget.addEventListener(Event.ENTER_FRAME,targetMove);
mcMissile.addEventListener(Event.ENTER_FRAME,missileTrack);
//
function moveHandler(e:MouseEvent):void{	
	pos = new Point(e.localX,e.localY);
}
//Ŀ������λ���ƶ�
function targetMove(e:Event):void{
	//����Ŀ������굱ǰλ�õľ���
	var dx:Number = pos.x-mcTarget.x;
    var dy:Number = pos.y-mcTarget.y;
	//����Ŀ�������λ�õļн�
	var angle = (270 + Math.atan2(dy, dx)*180/Math.PI)%360;
	//�ƶ�Ŀ��
	if(Math.abs(dx)>speed || Math.abs(dy)>speed){
		mcTarget.x -= speed*Math.sin(angle*Math.PI/180);	
		mcTarget.y += speed*Math.cos(angle*Math.PI/180);
	}	
}
//��������
function missileTrack(e:Event):void{
	var dx:Number = mcMissile.x-mcTarget.x;
    var dy:Number = mcMissile.y-mcTarget.y;
	//Ŀ����y��ļн�
    var angle = (270 + Math.atan2(dy, dx)*180/Math.PI)%360;
	//Ŀ���뵼���ļн�
	var crtangle = (angle - mcMissile.rotation + 360)%360;
	//�жϵ�����ת����
	var dir:Number = crtangle<=180?1:-1;
	mcMissile.rotation = (crtangle<180 && crtangle>omega || 
						  crtangle>180 && 360-crtangle>omega)? 
						 (mcMissile.rotation+omega*dir) : angle;
	//�ƶ�����
	mcMissile.x += misslespeed*Math.sin(mcMissile.rotation*Math.PI/180);	
	mcMissile.y -= misslespeed*Math.cos(mcMissile.rotation*Math.PI/180);
}